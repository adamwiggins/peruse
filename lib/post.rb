class Post < ActiveRecord::Base
	belongs_to :feed

	named_scope :unread, :conditions => { :rating => nil }

	validates_inclusion_of :rating, :in => %w(thumbs_up meh thumbs_down no_opinion), :allow_nil => true

	after_save :update_feed_score

	def update_feed_score
		if rating_changed?
			feed.save_score
		end
	end

	def self.pick_one
		feed = Feed.pick_one
		return nil unless feed
		feed.posts.find_all_by_rating(nil).rand
	end
end
