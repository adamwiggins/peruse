require 'sinatra'
require File.dirname(__FILE__) + '/lib/all'

layout 'layout'

helpers do
	def go_to_fresh_post
		post = Post.pick_one
		if post
			redirect "/posts/#{post.id}"
		else
			erb :nothing
		end
	end
end

get '/' do
	go_to_fresh_post
end

get '/posts/:id' do
	@post = Post.find(params[:id])
	erb :post
end

get '/posts/:id/update' do
	post = Post.find(params[:id])
	post.rating = params[:rating]
	post.save!
	go_to_fresh_post
end

get '/feeds/add' do
	erb :add_feed
end

post '/feeds' do
	Feed.create! :url => params[:url].strip
	go_to_fresh_post
end

get '/feeds' do
	@feeds = Feed.find(:all, :order => 'score desc')
	erb :feeds
end

get '/import' do
	erb :import
end

post '/import' do
	Feed.import(params[:file][:tempfile].read)
	go_to_fresh_post
end

