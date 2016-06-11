$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'celluloid/io'
require 'open-uri'
require 'slack-amber-alert/version'
require 'slack-amber-alert/info'
require 'slack-amber-alert/models'
require 'slack-amber-alert/api'
require 'slack-amber-alert/app'
require 'slack-amber-alert/server'
require 'slack-amber-alert/service'
require 'slack-amber-alert/commands'
