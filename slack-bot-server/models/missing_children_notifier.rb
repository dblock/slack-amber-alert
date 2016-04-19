module MissingChildrenNotifier
  class << self
    def notify!
      Mongoid.logger.info "Notify #{Team.active.count} team(s) ..."
      Team.active.each do |team|
        notify_team!(team)
      end
    end

    def notify_team!(team, client = nil)
      missing_children = if team.notified_at
                           MissingChild.where(:published_at.gt => team.notified_at).asc(:published_at)
                         else
                           MissingChild.all.desc(:published_at).limit(1)
                         end
      Mongoid.logger.info "Notify #{team.name} (#{team.notified_at}), #{missing_children.count} missing ..."
      return unless missing_children.any?
      client ||= Slack::Web::Client.new(token: team.token)
      channels = client.channels_list['channels'].select { |channel| channel['is_member'] }
      return unless channels.any?
      missing_children.each do |missing_child|
        channels.each do |channel|
          client.chat_postMessage(
            channel: channel['id'],
            as_user: true,
            attachments: [{
              fallback: missing_child.to_s,
              title_link: missing_child.link,
              title: missing_child.to_s,
              text: [
                missing_child.circumstance,
                "Missing since #{missing_child.missingDate.to_formatted_s(:long)}.",
                "Contact #{missing_child.altContact}."
              ].join("\n"),
              thumb_url: missing_child.photo,
              color: '#FF0000'
            }]
          )
        end
        team.update_attributes!(notified_at: missing_child.published_at)
      end
    end
  end
end
