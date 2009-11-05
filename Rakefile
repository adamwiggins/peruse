require File.dirname(__FILE__) + "/vendor/delayed_job/tasks/tasks"

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

desc "Interactive console"
task :console => :environment do
	require 'irb'
	ARGV.shift
	IRB.start
end

desc "Fetch new posts"
task 'posts:fetch' => :environment do
	Feed.refresh_stale
end

desc "Clean out old posts"
task 'posts:clean' => :environment do
	Feed.clean_old
end

desc "Call nightly to fetch new posts and clean out old ones"
task :cron => [ 'posts:clean', 'posts:fetch' ]
