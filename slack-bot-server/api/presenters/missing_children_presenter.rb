module Api
  module Presenters
    module MissingChildrenPresenter
      include Roar::JSON::HAL
      include Roar::Hypermedia
      include Grape::Roar::Representer
      include Api::Presenters::PaginatedPresenter

      collection :results, extend: MissingChildPresenter, as: :missing_children, embedded: true
    end
  end
end
