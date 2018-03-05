require 'nokogiri'
require 'open-uri'

class Puya

  def self.articles
    puyasubs = Nokogiri::HTML(open('http://puya.si'))
  end
  
  def self.test
    'hola mundo'
  end
  
end
