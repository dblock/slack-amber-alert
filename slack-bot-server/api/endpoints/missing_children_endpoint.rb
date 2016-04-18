module Api
  module Endpoints
    class MissingChildrenEndpoint < Grape::API
      format :json
      helpers Api::Helpers::CursorHelpers
      helpers Api::Helpers::SortHelpers
      helpers Api::Helpers::PaginationParameters

      namespace :missing_children do
        desc 'Get a missing child.'
        params do
          requires :id, type: String, desc: 'Missing Child ID.'
        end
        get ':id' do
          missing_child = MissingChild.find(params[:id]) || error!('Not Found', 404)
          present missing_child, with: Api::Presenters::MissingChildPresenter
        end

        desc 'Get all the missing children.'
        params do
          use :pagination
        end
        sort MissingChild::SORT_ORDERS
        get do
          missing_children = paginate_and_sort_by_cursor(MissingChild.all, default_sort_order: '-_id')
          present missing_children, with: Api::Presenters::MissingChildrenPresenter
        end
      end
    end
  end
end
