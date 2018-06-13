module SlackAmberAlert
  class Service < SlackRubyBotServer::Service
    def initialize
      @timers = Timers::Group.new
      super
    end

    def start_from_database!
      MissingKid.update!
      super
    end

    def run_periodic_timer!
      logger.info "Setting up periodic notification every #{notify_period} second(s)."
      @timers.every(notify_period) do
        MissingKid.update!
        MissingKidsNotifier.notify!
      rescue StandardError => e
        logger.error "Error in periodic notification: #{e.message}."
        logger.error e
      end
      loop { @timers.wait }
    end

    def notify_period
      (ENV['NOTIFY_PERIOD'] || (60 * 10)).to_i
    end
  end
end
