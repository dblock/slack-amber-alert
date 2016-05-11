module MissingKidsNotifier
  class << self
    def notify!
      Mongoid.logger.info "Notify #{Team.active.count} team(s) ..."
      Team.active.each do |team|
        notify_team!(team)
      end
    end

    def notify_team!(team, client = nil)
      missing_kids = if team.notified_at
                       MissingKid.where(:published_at.gt => team.notified_at).asc(:published_at)
                     else
                       MissingKid.all.desc(:published_at).limit(1)
                     end
      Mongoid.logger.info "Notify #{team.name} (#{team.notified_at}), #{missing_kids.count} missing ..."
      return unless missing_kids.any?
      client ||= Slack::Web::Client.new(token: team.token)
      channels = client.channels_list['channels'].select { |channel| channel['is_member'] }
      return unless channels.any?
      missing_kids.each do |missing_kid|
        channels.each do |channel|
          notify_missing_kid!(client, channel['id'], missing_kid)
          team.notified!(missing_kid.published_at)
        end
      end
    end

    def notify_missing_kid!(client, channel_id, missing_kid)
      Mongoid.logger.info "Notify #{missing_kid} on #{channel_id} ..."
      client.chat_postMessage(
        channel: channel_id,
        as_user: true,
        attachments: [{
          fallback: missing_kid.to_s,
          title_link: missing_kid.link,
          title: missing_kid.to_s,
          text: [
            missing_kid.circumstance,
            missing_kid.missingDate && "Missing since #{missing_kid.missingDate.to_formatted_s(:long)}.",
            missing_kid.altContact && "Contact #{missing_kid.altContact}."
          ].compact.join("\n"),
          thumb_url: missing_kid.photo,
          color: '#FF0000'
        }]
      )
    end
  end
end
