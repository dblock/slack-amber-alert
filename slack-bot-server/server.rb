module SlackBotServer
  class Server < SlackRubyBot::Server
    attr_accessor :team

    def initialize(attrs = {})
      @team = attrs[:team]
      fail 'Missing team' unless @team
      options = { token: @team.token }
      super(options)
      client.owner = @team
    end

    def restart!(wait = 1)
      # when an integration is disabled, a live socket is closed, which causes the default behavior of the client to restart
      # it would keep retrying without checking for account_inactive or such, we want to restart via service which will disable an inactive team
      EM.next_tick do
        logger.info "#{team.name}: socket closed, restarting ..."
        SlackBotServer::Service.restart! team, self, wait
        client.owner = team
      end
    end

    on :hello do |client, _data|
      EM.next_tick do
        MissingChildrenNotifier.notify_team!(client.owner, client.web_client)
      end
    end

    on :channel_joined do |client, data|
      send_welcome_message(client, data)
      notify_missing_children(client, data)
    end

    def self.send_welcome_message(client, data)
      return if client.owner.welcomed_at
      logger.info "#{client.owner.name}: Welcome."
      client.say(channel: data.channel['id'], text: "Thanks for installing the Missing Kids Bot - you're doing your part in helping out!")
      client.owner.update_attributes!(welcomed_at: Time.now.utc)
    end

    def self.notify_missing_children(client, data)
      # send missing children alerts
      missing_child = MissingChild.desc(:published_at).first
      return unless missing_child
      MissingChildrenNotifier.notify_missing_child!(client.web_client, data.channel, missing_child)
      client.owner.notified!(missing_child.published_at)
    end
  end
end
