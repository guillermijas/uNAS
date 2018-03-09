require 'sinatra'
require './puya'

enable :sessions

get '/' do
  redirect to('/puya')
end

get '/puya' do
  @message = session[:msg]
  session[:msg] = nil
  @posts = Puya.articles
  haml :puya
end

get '/download' do
  session[:msg] = Puya.download(params[:link], params[:title])
  redirect to('/puya')
end
