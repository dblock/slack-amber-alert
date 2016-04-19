require 'spec_helper'

describe MissingChild, vcr: { cassette_name: 'missing_children', allow_playback_repeats: true } do
  context '#update!' do
    it 'creates a record for each alert' do
      expect do
        MissingChild.update!
      end.to change(MissingChild, :count).by(8)
    end
  end
  context 'with existing records' do
    before do
      MissingChild.update!
    end
    it 'only creates new records' do
      MissingChild.all.limit(5).destroy
      expect(MissingChild.count).to eq 3
      expect do
        MissingChild.update!
      end.to change(MissingChild, :count).by(5)
    end
    it 'can be called twice' do
      expect do
        MissingChild.update!
      end.to_not change(MissingChild, :count)
    end
    it 'updates records that have changed' do
      first_child = MissingChild.asc(:_id).first
      first_child.update_attributes!(name: 'Updated')
      MissingChild.update!
      first_child.reload
      expect(first_child.name).to_not eq 'Updated'
    end
    it 'does not resave records that have not changed' do
      expect_any_instance_of(MissingChild).to_not receive(:save!)
      MissingChild.update!
    end
  end
end
