require 'sinatra'
require 'nokogiri'
require './puya'

get '/' do
  @posts = Puya.articles
  haml :puya
end

get '/puya' do
  @posts = Puya.articles
  haml :puya
end
