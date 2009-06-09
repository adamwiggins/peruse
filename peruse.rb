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

