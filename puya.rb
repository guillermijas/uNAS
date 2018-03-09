require 'nokogiri'
require 'open-uri'
require 'ap'

NAS_PATH = '/media/nas/videos'

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
      art.css('a img').map do |e|
        next unless e['src'].include? 'mega'
        parent = e.parent
        parent = parent.parent while parent.name != 'a' || parent.name == 'body'
        links << parent unless parent.name != 'a'
      end
      filtered_links << links.last
    end
    filtered_links
  end

  def self.download(puya_link, title)
    if puya_link.include?('puya.si')
      page = Nokogiri::HTML(open(puya_link))
      ciphertext = page.at('input[@name="crypted"]')['value']
      key = page.at('input[@name="jk"]')['value'].split("'")[1]
      link = `echo -n '#{ciphertext}' | openssl enc -d -AES-128-CBC -nosalt -nopad -base64 -A -K #{key} -iv #{key}`
      link.delete!("\000")
    end

    if link.include?('mega.nz')
      system("megadl '#{link}' --path #{NAS_PATH} > /dev/null 2>&1 &")
      "Downloading #{title}"
    else
      'Error'
    end
  end
end
