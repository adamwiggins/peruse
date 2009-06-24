class AddFeedScore < ActiveRecord::Migration
	def self.up
		add_column :feeds, :score, :integer

		Feed.all.each do |feed|
			feed.save_score
		end
	end
end
