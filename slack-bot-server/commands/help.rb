module SlackBotServer
  module Commands
    class Help < SlackRubyBot::Commands::Base
      HELP = <<-EOS
```
Amber Alert Slack Bot.

General
-------

children [n|inifinity]  - show missing kids
help                    - get this helpful message

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
