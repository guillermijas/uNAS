FROM ruby:3.1.1-alpine
LABEL maintainer="Guillermo Mora (guillermijas@gmail.com)"

RUN apk upgrade --update-cache --available && \
    apk add openssl build-base gcc libstdc++ libssl1.1 && \
    rm -rf /var/cache/apk/*

RUN gem update --system && gem install bundler 
RUN bundle config set without 'development:test'  

WORKDIR /app
ADD Gemfile* /app/
RUN bundle install

ADD . /app
