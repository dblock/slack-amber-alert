require 'spec_helper'

describe Api::Middleware do
  include Api::Test::EndpointTest

  context 'missingkids.org' do
    it 'redirects to www' do
      get '/', {}, 'SERVER_NAME' => 'missingkidsbot.org'
      expect(last_response.status).to eq 301
      expect(last_response.headers['Location']).to eq 'http://www.missingkidsbot.org/'
    end
    it 'redirects path to www' do
      get '/api/status', {}, 'SERVER_NAME' => 'missingkidsbot.org'
      expect(last_response.status).to eq 301
      expect(last_response.headers['Location']).to eq 'http://www.missingkidsbot.org/api/status'
    end
  end
end
