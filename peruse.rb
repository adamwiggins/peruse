require 'sinatra'

layout 'layout'

get '/' do
	erb :index
end

