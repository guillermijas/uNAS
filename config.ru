# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'yaml'
require 'telegram/bot'
require 'roda'
require 'tilt'
require 'open-uri'
require 'nokogiri'

require './app/app.rb'
require './app/puya.rb'

run App.freeze.app
