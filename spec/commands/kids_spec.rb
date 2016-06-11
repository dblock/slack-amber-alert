require 'spec_helper'

describe SlackAmberAlert::Commands::Kids do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackRubyBot::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_command) { SlackRubyBot::Hooks::Message.new }
  context 'with missing kids' do
    let!(:c1) { Fabricate(:missing_kid, published_at: 1.week.ago) }
    let!(:c2) { Fabricate(:missing_kid, published_at: 2.weeks.ago) }
    it 'displays missing sorted by published_at' do
      expect(client.web_client).to receive(:chat_postMessage).twice
      message_command.call(client, Hashie::Mash.new(text: "#{SlackRubyBot.config.user} kids", channel: 'channel', user: 'user'))
    end
    it 'limits to max' do
      expect(client.web_client).to receive(:chat_postMessage).once
      message_command.call(client, Hashie::Mash.new(text: "#{SlackRubyBot.config.user} kids 1", channel: 'channel', user: 'user'))
    end
    it 'fails for any number above 10' do
      expect(message: "#{SlackRubyBot.config.user} kids 11").to respond_with_slack_message 'Please specify a number between 1 and 10.'
    end
  end
  context 'without missing kids' do
    it 'says nothing' do
      expect(message: "#{SlackRubyBot.config.user} kids").to respond_with_slack_message 'No information on missing kids available.'
    end
  end
end
