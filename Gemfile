source 'http://rubygems.org'

ruby '2.2.4'

gem 'slack-ruby-bot-server'
gem 'rack-server-pages', github: 'dblock/rack-server-pages', branch: 'fix-at-filename'
gem 'simple-rss'
gem 'newrelic_rpm'
gem 'rack-robotz'

group :development, :test do
  gem 'rake', '~> 10.4'
  gem 'rubocop', '0.40.0'
  gem 'foreman'
end

group :development do
  gem 'mongoid-shell'
  gem 'heroku'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'webmock'
  gem 'vcr'
  gem 'fabrication'
  gem 'faker'
  gem 'database_cleaner'
  gem 'hyperclient'
  gem 'capybara'
  gem 'selenium-webdriver'
end
