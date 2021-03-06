# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'yaml'
require 'roda'
require 'tilt'
require 'open-uri'
require 'nokogiri'
require 'redis'

require 'dotenv/load' if ENV.fetch('RACK_ENV') != 'production'

require './app/app.rb'
require './app/puya.rb'

$redis = Redis.new(url: ENV['REDIS_URL'])
run App.freeze.app
