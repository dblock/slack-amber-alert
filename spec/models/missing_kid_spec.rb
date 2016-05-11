require 'spec_helper'

describe MissingKid, vcr: { cassette_name: 'missing_kids', allow_playback_repeats: true } do
  context '#update!' do
    it 'creates a record for each alert' do
      expect do
        MissingKid.update!
      end.to change(MissingKid, :count).by(8)
    end
  end
  context 'with existing records' do
    before do
      MissingKid.update!
    end
    it 'only creates new records' do
      MissingKid.all.limit(5).destroy
      expect(MissingKid.count).to eq 3
      expect do
        MissingKid.update!
      end.to change(MissingKid, :count).by(5)
    end
    it 'can be called twice' do
      expect do
        MissingKid.update!
      end.to_not change(MissingKid, :count)
    end
    it 'updates records that have changed' do
      first_kid = MissingKid.asc(:_id).first
      first_kid.update_attributes!(name: 'Updated')
      MissingKid.update!
      first_kid.reload
      expect(first_kid.name).to_not eq 'Updated'
    end
    it 'does not resave records that have not changed' do
      expect_any_instance_of(MissingKid).to_not receive(:save!)
      MissingKid.update!
    end
  end
end
