class CreateFeeds < ActiveRecord::Migration
	def self.up
		create_table :feeds do |t|
			t.text :url
			t.text :title
			t.timestamps
		end
	end
end
