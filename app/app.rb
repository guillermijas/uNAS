# frozen_string_literal: true

class App < Roda
  plugin :render, views: 'app/views'

  route do |r|
    @puya = Puya.new

    r.root do
      r.redirect('puya')
    end

    r.get do
      r.is 'puya' do
        view('puya', locals: { posts: @puya.home_articles, message: '' })
      end

      r.is 'download_puya' do
        message = @puya.download_puya_link(r.params['link'])
        view('puya', locals: { posts: @puya.home_articles, message: message })
      end

      r.is 'download_mega' do
        message = @puya.download_mega_link(r.params['link'])
        view('puya', locals: { posts: @puya.home_articles, message: message })
      end

      r.is 'search' do
        view('search', locals: { posts: @puya.search(r.params['search']),
                                 message: '', search: r.params['search'] })
      end

      r.is 'access_and_download' do
        message = @puya.access_and_download(r.params['link'])
        view('search', locals: { posts: @puya.search(r.params['search']),
                                 message: message, search: r.params['search'] })
      end
    end
  end
end
