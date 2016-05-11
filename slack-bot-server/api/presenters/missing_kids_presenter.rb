module Api
  module Presenters
    module MissingKidsPresenter
      include Roar::JSON::HAL
      include Roar::Hypermedia
      include Grape::Roar::Representer
      include Api::Presenters::PaginatedPresenter

      collection :results, extend: MissingKidPresenter, as: :missing_kids, embedded: true
    end
  end
end
