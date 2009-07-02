class Feed < ActiveRecord::Base
	has_many :posts, :dependent => :destroy

	validates_uniqueness_of :url

	after_create :refresh

	def refresh
		Delayed::Job.enqueue self
	end

	def perform
		feed = FeedTools::Feed.open(url)

		puts "Updating #{feed.title}"

		transaction do
			update_attribute(:title, feed.title)

			feed.items.each do |item|
				unless posts.find_by_url(item.link)
					posts.create! :title => item.title, :url => item.link, :author => item.author.name, :body => item.content
				end
			end
		end
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

	def self.import(opml)
		Nokogiri::HTML.parse(opml).search('outline').each do |item|
			Feed.create! :url => item[:xmlurl]
		end
	end
end
