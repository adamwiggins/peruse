task :environment do
	require File.dirname(__FILE__) + '/lib/all'
end

namespace :db do
	desc "Migrate the database"
	task :migrate => :environment do
		ActiveRecord::Base.logger = Logger.new(STDOUT)
		ActiveRecord::Migrator.migrate("db/migrate")
	end
end

desc "Interactive console"
task :console => :environment do
	require 'irb'
	ARGV.shift
	IRB.start
end

