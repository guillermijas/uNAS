require 'sinatra'
require 'nokogiri'
require './puya'

get '/' do
  haml :puya
end

get '/puya' do
  @text = Puya.articles
  haml :puya
end
