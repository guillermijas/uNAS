# frozen_string_literal: true

# Grab links from puya.moe and download the desired ones.
class Puya
  def home_articles(page = 0)
    main_page_posts = Nokogiri::HTML(URI.open("https://puya.moe?paged=#{page}"))
                              .xpath('//article[starts-with(@id, "post-")]')
    posts = []
    main_page_posts.each do |post|
      posts << decompose_post(post)
    end
    posts
  end

  def decompose_post(post)
    post_title = post.css('.entry-title a').text
    image_src = post.css('img.size-full').attr('src').value
    mega_link = post.css('.entry-content a[href^="https://puya.moe/enc"]')
                    .to_a.last.attr('href')
    { title: post_title, image: image_src, link: mega_link }
  rescue StandardError
    { title: nil, image: nil, link: nil }
  end

  def download_puya_link(link)
    return 'Error: bad Puya link' unless link.include?('puya.moe')

    page = Nokogiri::HTML(URI.open(link))
    ciphertext = page.at('input[@name="crypted"]')['value']
    key = page.at('input[@name="jk"]')['value'].split("'")[1]
    link = `echo -n '#{ciphertext}' | openssl enc -d -AES-128-CBC -nosalt -nopad -base64 -A -K #{key} -iv #{key}`
    link.delete!("\000")
    store_mega_link(link)
  end

  def store_mega_link(link)
    return 'Error: Bad mega link' unless link.include?('mega.nz')

    $redis.rpush('mega_links', link)
    "Added link #{link} to queue"
  end

  def fetch_mega_link
    $redis.lpop('mega_links')
  end

  def search(search_query)
    page = 1
    posts = []
    loop do
      link = "https://puya.moe/?s=#{search_query}&paged=#{page}"
      begin
        articles = Nokogiri::HTML(URI.open(link)).css('h2.entry-title')
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
    post = Nokogiri::HTML(URI.open(link))
    puya_enc_link = post.css('.entry-content a[href^="https://puya.moe/enc"]')
                        .to_a.last.attr('href')
    download_puya_link(puya_enc_link)
  end
end
