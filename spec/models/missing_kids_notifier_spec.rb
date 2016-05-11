require 'spec_helper'

describe MissingKidsNotifier do
  context 'without data' do
    it 'does not do anything' do
      subject.notify!
    end
  end
  context 'with a team and a missing kid' do
    let!(:team) { Fabricate(:team) }
    let!(:missing_kid) { Fabricate(:missing_kid) }
    let(:client) do
      double(Slack::Web::Client,
             channels_list: {
               'channels' => [
                 { 'id' => 'general', 'is_member' => true },
                 { 'id' => 'other', 'is_member' => false }
               ]
             }
            )
    end
    before do
      allow(Slack::Web::Client).to receive(:new).with(token: team.token).and_return(client)
    end
    it 'notifies a team about the missing kid' do
      expect(client).to receive(:chat_postMessage).with(
        channel: 'general',
        as_user: true,
        attachments: [{
          fallback: missing_kid.to_s,
          title_link: missing_kid.link,
          title: missing_kid.to_s,
          text: [
            missing_kid.circumstance,
            "Missing since #{missing_kid.missingDate.to_formatted_s(:long)}.",
            "Contact #{missing_kid.altContact}."
          ].join("\n"),
          color: '#FF0000',
          thumb_url: missing_kid.photo
        }]
      )
      subject.notify!
    end
    it 'updated team notified_at' do
      allow(client).to receive(:chat_postMessage)
      subject.notify!
      expect(team.reload.notified_at).to eq missing_kid.reload.published_at
    end
    it 'does not notify twice' do
      expect(client).to receive(:chat_postMessage).once
      2.times { subject.notify! }
    end
  end
end
