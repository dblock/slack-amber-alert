require 'spec_helper'

describe MissingChildrenNotifier do
  context 'without data' do
    it 'does not do anything' do
      subject.notify!
    end
  end
  context 'with a team and a missing child' do
    let!(:team) { Fabricate(:team) }
    let!(:missing_child) { Fabricate(:missing_child) }
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
    it 'notifies a team about the missing child' do
      expect(client).to receive(:chat_postMessage).with(
        channel: 'general',
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
          color: '#FF0000',
          image_url: missing_child.photo
        }]
      )
      subject.notify!
    end
    it 'updated team notified_at' do
      allow(client).to receive(:chat_postMessage)
      subject.notify!
      expect(team.reload.notified_at).to eq missing_child.reload.published_at
    end
    it 'does not notify twice' do
      expect(client).to receive(:chat_postMessage).once
      2.times { subject.notify! }
    end
  end
end
