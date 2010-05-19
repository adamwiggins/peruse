task :environment do
	require File.dirname(__FILE__) + '/lib/all'
	ActiveRecord::Base.logger = Logger.new('/dev/null')
end

namespace :db do
	desc "Migrate the database"
	task :migrate => :environment do
		ActiveRecord::Migrator.migrate("db/migrate")
	end
end
