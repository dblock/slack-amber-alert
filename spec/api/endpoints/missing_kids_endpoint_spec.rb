require 'spec_helper'

describe Api::Endpoints::MissingKidsEndpoint do
  include Api::Test::EndpointTest

  it_behaves_like 'a cursor api', MissingKid

  context 'missing kid' do
    let(:existing_missing_kid) { Fabricate(:missing_kid) }
    it 'returns a missing_kid' do
      missing_kid = client.missing_kid(id: existing_missing_kid.id)
      expect(missing_kid.id).to eq existing_missing_kid.id.to_s
      expect(missing_kid._links.self._url).to eq "http://example.org/api/missing_kids/#{existing_missing_kid.id}"
    end
  end
end
