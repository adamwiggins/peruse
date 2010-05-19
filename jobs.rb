include Stalker

require 'lib/all'

job 'feeds.clean' do
	Feed.clean_old
end

job 'feed.clean' do |args|
	Feed.find(args['id']).perform_clean
end

job 'feeds.fetch' do
	Feed.refresh
end

job 'feed.fetch' do |args|
	Feed.find(args['id']).perform_refresh
end
