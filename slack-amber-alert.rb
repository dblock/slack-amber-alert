ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('config/initializers', __dir__) + '/**/*.rb'].each do |file|
  require file
end

Mongoid.load! File.expand_path('config/mongoid.yml', __dir__), ENV['RACK_ENV']

require 'open-uri'
require 'slack-ruby-bot'
require 'slack-amber-alert/version'
require 'slack-amber-alert/info'
require 'slack-amber-alert/models'
require 'slack-amber-alert/api'
require 'slack-amber-alert/app'
require 'slack-amber-alert/server'
require 'slack-amber-alert/service'
require 'slack-amber-alert/commands'
