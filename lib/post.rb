class Post < ActiveRecord::Base
	belongs_to :feed

	validates_inclusion_of :rating, :in => %w(thumbs_up meh thumbs_down no_opinion), :allow_nil => true

	def self.pick_one
		find(:all, :conditions => "rating is null").rand
	end
end
