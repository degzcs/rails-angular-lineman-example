require 'cancancan'

module V1
  module Modules
    class Agreetments < Grape::API
      before_validation do
        authenticate!
      end

      helpers do
        params :pagination do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
      end

      format :json
      content_type :json, 'application/json'

      resource :agreetments do
        #
        # GET
        #

        desc 'returns the fixed sale agreetment text from settings which is set in ActiveAdmin app', {
          entity: V1::Entities::Agreetment,
          notes: <<-NOTES
            Returns the fixed sale agreetment text
          NOTES
        }

        params do
          #use :pagination
        end

        get '/fixed_sale', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          authorize! :read, ::Settings
          content_type "text/json"
          
          settings = ::Settings.instance
          present settings, with: V1::Entities::Agreetment
        end

        desc 'returns the buy agreetment between trader and authorized provider text from settings which is set in ActiveAdmin app', {
          entity: V1::Entities::Agreetment,
          notes: <<-NOTES
            returns the buy agreetment between trader and authorized provider
          NOTES
        }

        params do
          #use :pagination
        end

        get '/buy_agreetment', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          authorize! :read, ::Settings
          content_type "text/json"
          
          settings = ::Settings.instance
          present settings, with: V1::Entities::Agreetment
        end

      end
    end
  end
end