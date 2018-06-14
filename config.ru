$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

require 'slack-ruby-bot-server'
require 'slack-amber-alert'

Mongoid.load!(File.expand_path('config/mongoid.yml', __dir__), ENV['RACK_ENV'])

SlackAmberAlert::App.instance.prepare!

# Thread.new do
#  SlackAmberAlert::Service.start!
#  SlackAmberAlert::Service.instance.run_periodic_timer!
# end

run Api::Middleware.instance
