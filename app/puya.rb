# Grab links from puya.si and download the desired ones.
class Puya

  def home_articles
    main_page_posts = Nokogiri::HTML(open('http://puya.si')).css('article')
    posts = []
    main_page_posts.each do |post|
      posts << decompose_post(post)
    end
    posts
  end

  def decompose_post(post)
    post_title = post.css('.entry-title a').text
    image_src = post.css('img.size-full').attr('src').value
    mega_link = post.css('.entry-content a[href^="http://puya.si/enc"]')
                    .to_a.last.attr('href')
    { title: post_title, image: image_src, link: mega_link }
  rescue StandardError
    { title: nil, image: nil, link: nil }
  end

  def download_puya_link(link)
    return 'Error: bad Puya link' unless link.include?('puya.si')
    page = Nokogiri::HTML(open(link))
    ciphertext = page.at('input[@name="crypted"]')['value']
    key = page.at('input[@name="jk"]')['value'].split("'")[1]
    link = `echo -n '#{ciphertext}' | openssl enc -d -AES-128-CBC -nosalt -nopad -base64 -A -K #{key} -iv #{key}`
    link.delete!("\000")
    download_mega_link(link)
  end

  def download_mega_link(link)
    return 'Error: Bad mega link' unless link.include?('mega.nz')
    system("megadl '#{link}' --path #{ENV['NAS_PATH']} > /dev/null 2>&1 &")
    "Downloading #{link}"
  end

  def search(search_query)
    page = 1
    posts = []
    loop do
      link = "http://puya.si/?s=#{search_query}&paged=#{page}"
      begin
        articles = Nokogiri::HTML(open(link)).css('h2.entry-title')
      rescue OpenURI::HTTPError
        break
      end
      posts += articles.to_a
      page += 1
    end
    decompose_search(posts)
  end

  def decompose_search(posts)
    decomposed_posts = []
    posts.each do |post|
      post_title = post.css('a').text
      mega_link = post.css('a').attr('href').value
      decomposed_posts << { title: post_title, link: mega_link }
    end
    decomposed_posts
  end

  def access_and_download(link)
    post = Nokogiri::HTML(open(link))
    puya_enc_link = post.css('.entry-content a[href^="http://puya.si/enc"]')
                        .to_a.last.attr('href')
    download_puya_link(puya_enc_link)
  end
end
