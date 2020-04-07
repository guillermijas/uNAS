# frozen_string_literal: true

class App < Roda
  plugin :render, views: 'app/views'
  plugin :http_auth, authenticator: ->(user, pass) { [user, pass] == [ENV['LOGIN_USER'], ENV['LOGIN_PASS']] },
                     realm: 'Password required',
                     schemes: 'basic',
                     unauthorized: ->(_r) { view('401') }

  route do |r|
    @puya = Puya.new

    r.root do
      r.redirect('puya?page=1')
    end

    r.get 'status' do
      'OK'
    end

    r.get do
      http_auth

      r.is 'puya' do
        page = r.params['page']
        view('puya', locals: { posts: @puya.home_articles(page),
                               message: '', page: page })
      end

      r.is 'download_puya' do
        page = r.params['page']
        message = @puya.download_puya_link(r.params['link'])
        view('puya', locals: { posts: @puya.home_articles(page),
                               message: message, page: page })
      end

      r.is 'download_mega' do
        page = r.params['page']
        message = @puya.store_mega_link(r.params['link'])
        view('puya', locals: { posts: @puya.home_articles(page),
                               message: message })
      end

      r.is 'search' do
        view('search', locals: { posts: @puya.search(r.params['search']),
                                 message: '', search: r.params['search'] })
      end

      r.is 'fetch' do
        @puya.fetch_mega_link
      end

      r.is 'access_and_download' do
        message = @puya.access_and_download(r.params['link'])
        view('search', locals: { posts: @puya.search(r.params['search']),
                                 message: message, search: r.params['search'] })
      end
    end
  end
end
