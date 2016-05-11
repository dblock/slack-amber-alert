require 'spec_helper'

describe SlackBotServer::Server do
  let(:team) { Fabricate(:team) }
  let(:client) { subject.send(:client) }
  subject do
    SlackBotServer::Server.new(team: team)
  end
  context '#channel_joined' do
    it 'does nothing' do
      allow(client).to receive(:say)
      expect(client.web_client).to_not receive(:chat_postMessage)
      client.send(:callback, Hashie::Mash.new('channel' => { 'id' => 'C12345' }), :channel_joined)
    end
    context 'with a missing kid' do
      let!(:missing_kid) { Fabricate(:missing_kid) }
      it 'notifies about the missing kid and updates team notified timestamp' do
        allow(client).to receive(:say)
        expect(client.web_client).to receive(:chat_postMessage).once
        client.send(:callback, Hashie::Mash.new('channel' => { 'id' => 'C12345' }), :channel_joined)
        expect(team.reload.notified_at).to_not be nil
      end
      it 'sends a welcome message once' do
        expect(client).to receive(:say).with(channel: 'C12345', text: "Thanks for installing the Missing Kids Bot - you're doing your part in helping out!")
        expect(client.web_client).to receive(:chat_postMessage).twice
        2.times { client.send(:callback, Hashie::Mash.new('channel' => { 'id' => 'C12345' }), :channel_joined) }
        expect(team.reload.welcomed_at).to_not be nil
      end
    end
  end
end
