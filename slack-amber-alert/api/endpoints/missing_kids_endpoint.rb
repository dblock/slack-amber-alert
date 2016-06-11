module Api
  module Endpoints
    class MissingKidsEndpoint < Grape::API
      format :json
      helpers Api::Helpers::CursorHelpers
      helpers Api::Helpers::SortHelpers
      helpers Api::Helpers::PaginationParameters

      namespace :missing_kids do
        desc 'Get a missing kid.'
        params do
          requires :id, type: String, desc: 'Missing Kid ID.'
        end
        get ':id' do
          missing_kid = MissingKid.find(params[:id]) || error!('Not Found', 404)
          present missing_kid, with: Api::Presenters::MissingKidPresenter
        end

        desc 'Get all the missing kids.'
        params do
          use :pagination
        end
        sort MissingKid::SORT_ORDERS
        get do
          missing_kids = paginate_and_sort_by_cursor(MissingKid.all, default_sort_order: '-_id')
          present missing_kids, with: Api::Presenters::MissingKidsPresenter
        end
      end
    end
  end
end
