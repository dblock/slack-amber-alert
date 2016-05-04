module SlackBotServer
  module Commands
    class Children < SlackRubyBot::Commands::Base
      include Celluloid::IO

      command 'children' do |client, data, match|
        max = 3
        arguments = match['expression'].split.reject(&:blank?) if match['expression']
        arguments ||= []
        number = arguments.shift
        if number
          case number.downcase
          when 'infinity'
            max = nil
          else
            max = Integer(number)
          end
        end
        Celluloid.defer do
          children = MissingChild.all.desc(:published_at).limit(max)
          if children.any?
            children.each do |missing_child|
              MissingChildrenNotifier.notify_missing_child!(client.web_client, data.channel, missing_child)
            end
          else
            client.say(channel: data.channel, text: 'No information on missing children available.')
          end
        end
        logger.info "MISSING #{max || '∞'}: #{client.owner} - #{data.user}"
      end
    end
  end
end
