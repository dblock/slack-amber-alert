module SlackAmberAlert
  module Commands
    class Kids < SlackRubyBot::Commands::Base
      include Celluloid::IO

      command 'kids' do |client, data, match|
        max = 3
        arguments = match['expression'].split.reject(&:blank?) if match['expression']
        arguments ||= []
        number = arguments.shift
        max = Integer(number) if number
        raise 'Please specify a number between 1 and 10.' if max < 1 || max > 10
        Celluloid.defer do
          kids = MissingKid.all.desc(:published_at).limit(max)
          if kids.any?
            kids.each do |missing_kid|
              MissingKidsNotifier.notify_missing_kid!(client.web_client, data.channel, missing_kid)
            end
          else
            client.say(channel: data.channel, text: 'No information on missing kids available.')
          end
        end
        logger.info "MISSING #{max || '∞'}: #{client.owner} - #{data.user}"
      end
    end
  end
end
