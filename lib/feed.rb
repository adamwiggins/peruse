class Feed < ActiveRecord::Base
	has_many :posts, :dependent => :destroy

	validates_uniqueness_of :url

	after_create :refresh

	def to_s
		title || url
	end

	def refresh
		send_later :perform_refresh
	end

	def perform_refresh
		print "[#{Time.now}] Updating #{self}..."

		feed = FeedTools::Feed.open(url)

		transaction do
			update_attribute(:title, feed.title)

			count = 0
			feed.items.each do |item|
				next if posts.find_by_url(item.link)
				next if item.published and item.published < 2.months.ago

				posts.create! :title => item.title, :url => item.link, :author => item.author.name, :body => item.content, :published_at => item.published
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
		send_later :perform_clean
	end

	def unread_max
		(score || 0) + 10
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
		find(:all, :conditions => "(select count(*) from posts where feed_id=feeds.id and rating is null)>0")
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
			feed = feeds.rand
			return feed if (feed.score || 0) > rand_range(-10, 10) or rand_range(0, 99) == 0
		end

		raise "Infinte loop trying to pick a feed"
	end

	def self.find_stale
		find(:all, :conditions => [ "updated_at < ?", 30.minutes.ago ])
	end

	def self.refresh_stale
		find_stale.each { |feed| feed.refresh }
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
