require 'sinatra'
require File.dirname(__FILE__) + '/lib/all'

layout 'layout'

get '/' do
	@post = Post.pick_one
	if @post
		erb :index
	else
		erb :nothing
	end
end

get '/posts/:id/update' do
	post = Post.find(params[:id])
	post.rating = params[:rating]
	post.save!
	redirect '/'
end

get '/feeds/add' do
	erb :add_feed
end

post '/feeds' do
	Feed.create! :url => params[:url].strip
	redirect '/'
end

get '/import' do
	erb :import
end

post '/import' do
	Feed.import(params[:file][:tempfile].read)
	redirect '/'
end

