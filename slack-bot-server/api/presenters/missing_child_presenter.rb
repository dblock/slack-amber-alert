module Api
  module Presenters
    module MissingChildPresenter
      include Roar::JSON::HAL
      include Roar::Hypermedia
      include Grape::Roar::Representer

      property :id, type: String, desc: 'Missing Child ID.'
      property :title, type: String, desc: 'Missing child record title.'
      property :description, type: String, desc: 'Missing child description.'
      property :link, type: String, desc: 'Public link.'
      property :published_at, type: DateTime, desc: 'Date/time when the record was published in the registry of missing children.'
      property :created_at, type: DateTime, desc: 'Date/time when the record was created.'
      property :updated_at, type: DateTime, desc: 'Date/time when the record was updated.'

      link :self do |opts|
        request = Grape::Request.new(opts[:env])
        "#{request.base_url}/api/missing_children/#{id}"
      end
    end
  end
end
