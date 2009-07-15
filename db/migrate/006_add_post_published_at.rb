class AddPostPublishedAt < ActiveRecord::Migration
	def self.up
		add_column :posts, :published_at, :timestamp
	end
end
