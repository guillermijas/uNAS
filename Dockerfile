ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-alpine
LABEL maintainer="Guillermo Mora (guillermo@cleverppc.com)"

RUN apk upgrade --update-cache --available && \
    apk add openssl build-base gcc libstdc++ libssl1.1 && \
    rm -rf /var/cache/apk/*

RUN gem update --system && gem install bundler 
RUN bundle config set without 'development:test'  

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app
