require File.dirname(__FILE__) + '/../.bundle/environment'
Bundler.setup

require 'active_record'
require 'feed_tools'
require 'nokogiri'
require 'stalker'

if File.exists? 'config/database.yml'
	dbconfig = YAML.load(File.read('config/database.yml'))
	ActiveRecord::Base.establish_connection dbconfig['production']
else
	ActiveRecord::Base.establish_connection :adapter => 'postgresql', :database => 'peruse'
end

require File.dirname(__FILE__) + '/feed'
require File.dirname(__FILE__) + '/post'

