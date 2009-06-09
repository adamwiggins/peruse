class CreatePosts < ActiveRecord::Migration
	def self.up
		create_table :posts do |t|
			t.integer :feed_id
			t.text :url
			t.text :title
			t.text :author
			t.text :body
			t.timestamps
		end
	end
end
