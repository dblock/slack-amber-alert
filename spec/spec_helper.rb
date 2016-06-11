$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

ENV['RACK_ENV'] = 'test'

require 'slack-ruby-bot-server'
require 'slack-amber-alert'

require 'slack-ruby-bot/rspec'

Mongoid.load!(File.expand_path('../config/mongoid.yml', __dir__), ENV['RACK_ENV'])

Dir[File.join(File.dirname(__FILE__), 'support', '**/*.rb')].each do |file|
  require file
end
