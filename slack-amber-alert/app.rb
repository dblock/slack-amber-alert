module SlackAmberAlert
  class App < SlackRubyBotServer::App
    def prepare!
      super
      disable_gifs!
    end

    private

    def disable_gifs!
      SlackRubyBot.configure do |config|
        config.send_gifs = false
      end
    end
  end
end
