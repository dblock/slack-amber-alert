require 'spec_helper'

describe SlackBotServer::Service do
  let(:team) { Fabricate(:team) }
  let(:server) { SlackBotServer::Server.new(team: team) }
  let(:service) { SlackBotServer::Service.instance }
  let(:services) { service.instance_variable_get(:@services) }
  before do
    allow(SlackBotServer::Server).to receive(:new).with(team: team).and_return(server)
    allow(Celluloid).to receive(:defer).and_yield
    allow(server).to receive(:stop!)
  end
  after do
    service.reset!
  end
  it 'starts a team' do
    expect(server).to receive(:start_async)
    service.start!(team)
  end
  context 'started team' do
    before do
      allow(server).to receive(:start_async)
      service.start!(team)
    end
    it 'registers team service' do
      expect(services.size).to eq 1
      expect(services[team.token]).to eq server
    end
    it 'removes team service' do
      service.stop!(team)
      expect(services.size).to eq 0
    end
    it 'deactivates a team' do
      service.deactivate!(team)
      expect(team.reload.active).to be false
      expect(services.size).to eq 0
    end
  end
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
      timers = SlackBotServer::Service.instance.instance_variable_get(:@timers)
      expect(MissingChild).to receive(:update!).at_least(2).times
      expect(MissingChildrenNotifier).to receive(:notify!).at_least(2).times
      detached_thread = Thread.new do
        SlackBotServer::Service.instance.run_periodic_timer!
      end
      sleep 3
      allow(timers).to receive(:wait) { Thread.exit }
      timers.cancel
      detached_thread.join
    end
  end
end
