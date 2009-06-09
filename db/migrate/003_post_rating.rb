class PostRating < ActiveRecord::Migration
	def self.up
		add_column :posts, :rating, :text
	end
end
