module V1
  module Modules
    class City <  Grape::API

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
          requires :id, type: Integer, desc: 'City ID'
        end

      end

      resource :cities do
        desc 'returns all existent cities', {
          entity: V1::Entities::City,
          notes: <<-NOTES
            Returns all existent cities
          NOTES
        }
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          cities = ::City.all
          present cities, with: V1::Entities::City
        end
        desc 'returns one existent city registry by :id', {
          entity: V1::Entities::City,
          notes: <<-NOTES
            Returns a city by its :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          city = ::City.find(params[:id])
          present city, with: V1::Entities::City
        end
        desc 'returns all population centers from a city', {
          entity: V1::Entities::City,
          notes: <<-NOTES
            returns all population centers from a city
          NOTES
        }
        params do
          use :id
        end
        get '/:id/population_centers', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          city = ::City.find(params[:id])
          population_centers = city.population_centers
          present population_centers, with: V1::Entities::PopulationCenter
        end
      end
    end
  end
end