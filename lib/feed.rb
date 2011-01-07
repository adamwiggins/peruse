class Feed < ActiveRecord::Base
	has_many :posts, :dependent => :destroy

	validates_uniqueness_of :url

	after_create :refresh

	def to_s
		title || url
	end

	def refresh
		Stalker.enqueue('feed.fetch', :id => id)
	end

	def perform_refresh
		print "[#{Time.now}] Updating #{self}..."

		feed = Feedzirra::Feed.fetch_and_parse(Feedbag.find(url).first)

		transaction do
			update_attribute(:title, feed.title)

			count = 0
			feed.entries.each do |item|
        url = item.entry_id
        published = Time.parse(item.published)

				next if posts.find_by_url(url)
				next if published and published < 2.months.ago

				posts.create! :title => item.title, :url => url, :author => item.author, :body => item.content, :published_at => published
				count += 1
			end
			puts "#{count} new posts"
		end
	rescue Object => e
		puts "failed"
		puts "   #{e.class} (#{e.message}):"
		puts e.backtrace.map { |l| "   #{l}" }.join("\n")
	end

	def clean
		Stalker.enqueue('feed.clean', :id => id)
	end

	def unread_max
		8
	end

	def oldest_unread_posts(count)
		posts.unread.find(:all, :limit => count, :order => "published_at,created_at")
	end

	def perform_clean
		count = posts.unread.count

		print "[#{Time.now}] #{self} has #{count}/#{unread_max} unread posts"

		diff = count - unread_max
		if diff > 0
			print ", deleting #{diff}"
			oldest_unread_posts(diff).each { |post| post.destroy }
		end

		puts "."
	rescue Object => e
		puts "failed"
		puts "   #{e.class} (#{e.message}):"
		puts e.backtrace.map { |l| "   #{l}" }.join("\n")
	end

	def calc_score
		up = posts.count(:conditions => { :rating => 'thumbs_up' })
		meh = posts.count(:conditions => { :rating => 'meh' })
		down = posts.count(:conditions => { :rating => 'thumbs_down' })
		(up * 2) - meh - (down * 2)
	end

	def save_score
		self.score = calc_score
		save!
	end

	def self.find_has_unread_posts
		find(:all, :conditions => "exists(select * from posts where feed_id=feeds.id and rating is null)")
	end

	def self.pick_one
		pick_from(find_has_unread_posts)
	end

	def self.rand_range(min, max)
		rand(max - min) + min
	end

	def self.pick_from(feeds)
		return nil if feeds.empty?

		1000.times do
			feed = feeds.sample
			return feed if (feed.score || 0) > rand_range(-10, 10) or rand_range(0, 99) == 0
		end

		raise "Infinte loop trying to pick a feed"
	end

	def self.find_stale
		find(:all, :conditions => [ "updated_at < ?", 30.minutes.ago ])
	end

	def self.refresh
		all.each { |feed| feed.refresh }
	end

	def self.clean_old
		all.each { |feed| feed.clean }
	end

	def self.import(opml)
		Nokogiri::HTML.parse(opml).search('outline').each do |item|
			Feed.create! :url => item[:xmlurl]
		end
	end
end
