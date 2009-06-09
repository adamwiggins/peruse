require 'sinatra'
require File.dirname(__FILE__) + '/lib/all'

layout 'layout'

get '/' do
	@post = Post.first
	erb :index
end

