# Grab links from puya.si and download the desired ones.
class Puya
  require 'nokogiri'
  require 'open-uri'
  require 'ap'
  NAS_PATH = '/media/nas/videos'.freeze
  # NAS_PATH = '/home/guillermo/Escritorio'.freeze

  def home_articles
    articles = Nokogiri::HTML(open('http://puya.si')).css('article')
    titles = articles.map { |e| e.css('h2').text.strip }
    links = home_links(articles)
    result = {}
    titles.zip(links) { |k, v| result[k.to_sym] = v.values.first unless v.nil? }
    result
  end

  def home_links(articles)
    home_links = []
    articles.each do |art|
      links = []
      art.css('a img').map do |e|
        next unless e['src'].include? 'mega'
        links << parent_link(e)
      end
      home_links << links.last
    end
    home_links
  end

  def parent_link(img)
    parent = img.parent
    parent = parent.parent while parent.name != 'a' || parent.name == 'body'
    return nil if parent.name != 'a'
    parent
  end

  def download_link(puya_link, title)
    if puya_link.include?('puya.si')
      page = Nokogiri::HTML(open(puya_link))
      ciphertext = page.at('input[@name="crypted"]')['value']
      key = page.at('input[@name="jk"]')['value'].split("'")[1]
      link = `echo -n '#{ciphertext}' | openssl enc -d -AES-128-CBC -nosalt -nopad -base64 -A -K #{key} -iv #{key}`
      link.delete!("\000")
    else
      link = puya_link
    end

    if link.include?('mega.nz')
      system("megadl '#{link}' --path #{NAS_PATH} > /dev/null 2>&1 &")
      "Downloading #{title}"
    else
      'Error'
    end
  end

  def article_chapter(puya_title)
    title = puya_title.delete('–')
    title.gsub!('[Final]', '')
    title.gsub!('[V2]', '')
    title.gsub!('[1080p]', '')
    title.gsub!('[720p]', '')
    if title.include?('[Batch]')
      chapter = 'Batch'
      title.gsub!('[Batch]', '')
    else
      chapter = ''
      chapter = title.split[-1] unless title == title.split[-1]
      title.gsub!(chapter, '')
    end
    [title, chapter]
  end

  def search(search_query)
    page = 1
    found_articles = []

    loop do
      link = "http://puya.si/?s=#{search_query}&paged=#{page}"
      begin
        articles = Nokogiri::HTML(open(link)).css('h2.entry-title')
      rescue OpenURI::HTTPError
        break
      end
      found_articles += articles.to_a
      page += 1
    end
    found_articles
  end

  def open_and_get_link(puya_link)
    article = Nokogiri::HTML(open(puya_link))
    links = []
    article.css('a img').map do |e|
      next unless e['src'].include? 'mega'
      links << parent_link(e)
    end
    return if links.empty?
    links.last['href']
  end
end
