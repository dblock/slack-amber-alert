require 'spec_helper'

describe SlackBotServer::Server do
  let(:team) { Fabricate(:team) }
  let(:client) { subject.send(:client) }
  subject do
    SlackBotServer::Server.new(team: team)
  end
  context '#channel_joined' do
    it 'does nothing' do
      expect(client.web_client).to_not receive(:chat_postMessage)
      client.send(:callback, nil, :channel_joined)
    end
    context 'with a missing child' do
      let!(:missing_child) { Fabricate(:missing_child) }
      it 'notifies about the missing child and updates team notified timestamp' do
        expect(client.web_client).to receive(:chat_postMessage).once
        client.send(:callback, Hashie::Mash.new('channel' => { 'id' => 'C12345' }), :channel_joined)
        expect(team.reload.notified_at).to_not be nil
      end
    end
  end
end
