require 'spec_helper'

describe SlackAmberAlert::Service do
  let(:team) { Fabricate(:team) }
  let(:server) { SlackRubyBotServer::Server.new(team: team) }
  let(:service) { SlackAmberAlert::Service.instance }
  context 'notify_period' do
    context 'default' do
      before do
        ENV.delete 'NOTIFY_PERIOD'
      end
      it 'defaults to 10 minutes' do
        expect(service.notify_period).to eq 60 * 10
      end
    end
    context 'env' do
      before do
        ENV['NOTIFY_PERIOD'] = '30'
      end
      after do
        ENV.delete 'NOTIFY_PERIOD'
      end
      it 'uses NOTIFY_PERIOD' do
        expect(service.notify_period).to eq 30
      end
    end
  end
  context 'run_periodic_timer!' do
    before do
      ENV['NOTIFY_PERIOD'] = '1'
    end
    after do
      ENV.delete 'NOTIFY_PERIOD'
    end
    it 'loops' do
      timers = SlackAmberAlert::Service.instance.instance_variable_get(:@timers)
      expect(MissingKid).to receive(:update!).at_least(2).times
      expect(MissingKidsNotifier).to receive(:notify!).at_least(2).times
      detached_thread = Thread.new do
        SlackAmberAlert::Service.instance.run_periodic_timer!
      end
      sleep 3
      allow(timers).to receive(:wait) { Thread.exit }
      timers.cancel
      detached_thread.join
    end
  end
end
