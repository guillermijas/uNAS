require 'nokogiri'
require 'open-uri'
require 'ap'

class Puya
  def self.articles
    articles = Nokogiri::HTML(open('http://puya.si')).css('article')
    titles = articles.map { |e| e.css('h2').text.strip }
    links = get_links(articles)

    result = {}

    titles.zip(links) { |k, v| result[k.to_sym] = v.values.first unless v.nil? }
    result
  end

  def self.get_links(articles)
    filtered_links = []
    articles.each do |art|
      links = []
      art.css('a img').map { |e| links << e.parent if e['src'].include? 'mega' }
      filtered_links << links.last
    end
    filtered_links
  end
end
