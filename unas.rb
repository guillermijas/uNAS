require 'sinatra'
require './puya'

enable :sessions

before do
  @puya = Puya.new
end

get '/' do
  redirect to('/puya')
end

get '/puya' do
  @message = session[:msg]
  session[:msg] = nil
  @posts = @puya.home_articles
  haml :puya
end

get '/search' do
  @message = session[:msg]
  session[:msg] = nil
  @posts = @puya.search(params[:anime])
  haml :search
end

get '/download' do
  session[:msg] = @puya.download_link(params[:link], params[:title])
  redirect back
end

post '/download' do
  session[:msg] = @puya.download_link(params[:link], 'from Mega')
  redirect back
end
