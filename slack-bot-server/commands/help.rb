module SlackBotServer
  module Commands
    class Help < SlackRubyBot::Commands::Base
      HELP = <<-EOS
```
Missing Kids Slack Bot.

General
-------

kids [n]  - show missing kids (n can be 1-10, default is 3)
help      - get this helpful message

```
EOS
      def self.call(client, data, _match)
        client.say(channel: data.channel, text: [HELP, SlackBotServer::INFO].join("\n"))
        client.say(channel: data.channel, gif: 'help')
        logger.info "HELP: #{client.owner}, user=#{data.user}"
      end
    end
  end
end
