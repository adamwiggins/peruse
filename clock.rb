require 'stalker'
include Stalker

require 'clockwork'
include Clockwork

every('1d', :at => '02:30') { enqueue('feeds.clean') }
every('1d', :at => '02:50') { enqueue('feeds.fetch') }
