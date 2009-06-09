class Feed < ActiveRecord::Base
	after_create :refresh

	def refresh
		feed = FeedTools::Feed.open(url)

		update_attribute(:title, feed.title)
	end
end
