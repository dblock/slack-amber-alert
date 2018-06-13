$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'fabrication'
require 'faker'
require 'hyperclient'
require 'vcr'
require 'webmock/rspec'

ENV['RACK_ENV'] = 'test'

require 'slack-ruby-bot/rspec'
require 'slack-amber-alert'

Dir[File.join(File.dirname(__FILE__), 'support', '**/*.rb')].each do |file|
  require file
end
