require 'spec_helper'

describe Api::Endpoints::MissingChildrenEndpoint do
  include Api::Test::EndpointTest

  it_behaves_like 'a cursor api', MissingChild

  context 'missing child' do
    let(:existing_missing_child) { Fabricate(:missing_child) }
    it 'returns a missing_child' do
      missing_child = client.missing_child(id: existing_missing_child.id)
      expect(missing_child.id).to eq existing_missing_child.id.to_s
      expect(missing_child._links.self._url).to eq "http://example.org/api/missing_children/#{existing_missing_child.id}"
    end
  end
end
