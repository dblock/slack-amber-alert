module SlackAmberAlert
  class App < SlackRubyBotServer::App
    include Celluloid

    def after_start!
      once_and_every 60 * 3 do
        ping_teams!
      end
    end

    private

    def ping_teams!
      Team.active.each do |team|
        ping = team.ping!
        next if ping[:presence].online
        logger.warn "DOWN: #{team}"
        after 60 do
          ping = team.ping!
          unless ping[:presence].online
            logger.info "RESTART: #{team}"
            SlackAmberAlert::Service.instance.start!(team)
          end
        end
      rescue StandardError => e
        logger.warn "Error pinging team #{team}, #{e.message}."
      end
    end
  end
end
