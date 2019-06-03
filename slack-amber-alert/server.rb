module SlackRubyBotServer
  class Server < SlackRubyBot::Server
    WELCOME_MESSAGE = <<~EOS.freeze
      Thanks for installing the Missing Kids Bot - you're doing your part in helping out!
      When an Amber Alert is issued, I'll post a notification to this channel. You can also DM me to get the latest alerts.
    EOS

    on :hello do |client, _data|
      MissingKidsNotifier.notify_team!(client.owner, client.web_client)
    end

    on :channel_joined do |client, data|
      send_welcome_message(client, data)
      notify_missing_kids(client, data)
    end

    def self.send_welcome_message(client, data)
      return if client.owner.welcomed_at

      logger.info "#{client.owner.name}: Welcome."
      client.say(channel: data.channel['id'], text: WELCOME_MESSAGE)
      client.owner.update_attributes!(welcomed_at: Time.now.utc)
    end

    def self.notify_missing_kids(client, data)
      # send missing kids alerts
      missing_kid = MissingKid.desc(:published_at).first
      return unless missing_kid

      MissingKidsNotifier.notify_missing_kid!(client.web_client, data.channel['id'], missing_kid)
      client.owner.notified!(missing_kid.published_at)
    end
  end
end
