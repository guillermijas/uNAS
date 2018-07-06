FROM ruby:2.5.1-slim

RUN mkdir -p /app
ADD . /app

RUN gem install bundler
RUN gem install puma
RUN gem install sqlite3
RUN bundle install
ENV NAS_PATH /media/nas/videos

EXPOSE 3000

# The default command that gets ran will be to start the Puma server.
CMD bundle exec puma -C config/puma.rb