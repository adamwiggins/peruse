require 'sinatra'
require 'feed_tools'

layout 'layout'

get '/' do
	@feed = FeedTools::Feed.open('http://www.igvita.com/')
	@post = @feed.items[0]
	erb :index
end

