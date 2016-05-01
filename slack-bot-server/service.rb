module SlackBotServer
  class Service
    include SlackRubyBot::Loggable

    LOCK = Mutex.new
    @services = {}
    @timers = Timers::Group.new

    class << self
      def start!(team)
        fail 'Token already known.' if @services.key?(team.token)
        logger.info "Starting team #{team}."
        server = SlackBotServer::Server.new(team: team)
        LOCK.synchronize do
          @services[team.token] = server
        end
        restart!(team, server)
      rescue StandardError => e
        logger.error e
      end

      def stop!(team)
        Celluloid.defer do
          LOCK.synchronize do
            fail 'Token unknown.' unless @services.key?(team.token)
            logger.info "Stopping team #{team}."
            @services[team.token].stop!
            @services.delete(team.token)
          end
        end
      rescue StandardError => e
        logger.error e
      end

      def start_from_database!
        MissingChild.update!
        Team.active.each do |team|
          start!(team)
        end
        @timers.every((ENV['NOTIFY_PERIOD'] || (60 * 10)).to_i) do
          MissingChild.update!
          MissingChildrenNotifier.notify!
        end
      end

      def restart!(team, server, wait = 1)
        server.start_async
      rescue StandardError => e
        case e.message
        when 'account_inactive', 'invalid_auth' then
          logger.error "#{team.name}: #{e.message}, team will be deactivated."
          deactivate!(team)
        else
          logger.error "#{team.name}: #{e.message}, restarting in #{wait} second(s)."
          sleep(wait)
          Celluloid.defer do
            restart! team, server, [wait * 2, 60].min
          end
        end
      end

      def deactivate!(team)
        team.deactivate!
        LOCK.synchronize do
          @services.delete(team.token)
        end
      rescue Mongoid::Errors::Validations => e
        logger.error "#{team.name}: #{e.message}, error - #{e.document.class}, #{e.document.errors.to_hash}, ignored."
      rescue StandardError => e
        logger.error "#{team.name}: #{e.class}, #{e.message}, ignored."
      end

      def reset!
        @services.values.to_a.each do |server|
          stop!(server.team)
        end
      end
    end
  end
end
