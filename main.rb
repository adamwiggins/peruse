require 'sinatra'
require 'json'

require File.dirname(__FILE__) + '/lib/all'

get '/' do
	post = Post.pick_one
	if post
		redirect "/posts/#{post.id}"
	else
		erb :nothing
	end
end

get '/posts/:id' do
	@post = Post.find(params[:id])
	erb :post
end

get '/posts/:id/update' do
	post = Post.find(params[:id])
	post.rating = params[:rating]
	post.save!
	redirect '/'
end

get '/admin' do
	erb :admin
end

get '/feeds/add' do
	erb :add_feed
end

post '/feeds' do
	@feed = Feed.create :url => params[:url].strip
	erb :feed_added
end

get '/feeds' do
	@feeds = Feed.find(:all, :order => 'score desc')
	erb :feeds
end

get '/posts' do
	@posts = Post.find(:all, :conditions => "rating='thumbs_up'", :order => 'updated_at desc')
	erb :posts
end

get '/posts.json' do
	content_type 'application/json'
	posts = Post.find(:all, :conditions => "rating is not null", :order => 'updated_at desc')
	posts.map do |post|
		{
			:title => post.title,
			:url => post.url,
			:author => post.author,
			:published_at => post.published_at,
			:feed => post.feed.url,
			:feed_title => post.feed.title,
			:rating => post.rating
		}
	end.to_json
end

get '/feeds.json' do
	content_type 'application/json'
	Feed.all.map { |feed| feed.url }.to_json
end

get '/import' do
	erb :import
end

post '/import' do
	Feed.import(params[:file][:tempfile].read)
	go_to_fresh_post
end

