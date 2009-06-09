require 'activerecord'
require 'feed_tools'
require 'nokogiri'

if File.exists? 'config/database.yml'
	dbconfig = YAML.load(File.read('config/database.yml'))
	ActiveRecord::Base.establish_connection dbconfig['production']
else
	ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => 'the.db'
end

require File.dirname(__FILE__) + '/feed'
require File.dirname(__FILE__) + '/post'

