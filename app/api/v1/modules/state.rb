module V1
  module Modules
    class State <  Grape::API

      before_validation do
        authenticate!
      end

      format :json
      content_type :json, 'application/json'

      helpers do
        
        params :pagination do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end

        params :id do
          requires :id, type: Integer, desc: 'State ID'
        end

      end

      resource :states do
        desc 'returns all existent states', {
          entity: V1::Entities::State,
          notes: <<-NOTES
            Returns all existent states
          NOTES
        }
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          states = ::State.all
          present states, with: V1::Entities::State
        end
        desc 'returns one existent state registry by :id', {
          entity: V1::Entities::State,
          notes: <<-NOTES
            Returns one existent states by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          state = ::State.find(params[:id])
          present state, with: V1::Entities::State
        end
        desc 'returns all cities from a state', {
          entity: V1::Entities::State,
          notes: <<-NOTES
            Returns one existent states by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id/cities', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          state = ::State.find(params[:id])
          cities = state.cities
          present cities, with: V1::Entities::City
        end
      end
    end
  end
end