module V1
  module Modules
    class PopulationCenter <  Grape::API

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
          requires :id, type: Integer, desc: 'Population Center ID'
        end

      end

      resource :population_centers do
        desc 'returns all existent cities', {
          entity: V1::Entities::PopulationCenter,
          notes: <<-NOTES
            Returns all existent cities
          NOTES
        }
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          cities = ::PopulationCenter.all
          present cities, with: V1::Entities::PopulationCenter
        end
        desc 'returns one existent population_center registry by :id', {
          entity: V1::Entities::PopulationCenter,
          notes: <<-NOTES
            Returns a population_center by its :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          population_center = ::PopulationCenter.find(params[:id])
          present population_center, with: V1::Entities::PopulationCenter
        end
      end
    end
  end
end