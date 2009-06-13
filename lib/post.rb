class Post < ActiveRecord::Base
	belongs_to :feed

	validates_inclusion_of :rating, :in => %w(thumbs_up meh thumbs_down no_opinion), :allow_nil => true

	def self.pick_one
		feed = Feed.pick_one
		return nil unless feed
		feed.posts.find_all_by_rating(nil).rand
	end
end
