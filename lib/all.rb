require File.dirname(__FILE__) + '/../.bundle/environment'
Bundler.setup

require 'active_record'
require 'feed_tools'
require 'nokogiri'
require 'stalker'
require 'uri'

db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/peruse')

ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:host => db.host,
	:database => db.path.gsub(/\//, ''),
	:username => db.user || 'postgres',
	:password => db.password,
	:encoding => 'utf8'
)

require File.dirname(__FILE__) + '/feed'
require File.dirname(__FILE__) + '/post'

