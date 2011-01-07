require 'active_record'
require 'nokogiri'
require 'feedzirra'
require 'feedbag'
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

