module V1
  module Modules
    class Provider <  Grape::API

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

        params :auth do
          requires :access_token, type: String, desc: 'Auth token', documentation: { example: '837f6b854fc7802c2800302e' }
        end

        params :id do
          requires :id, type: String, desc: 'User ID', regexp: /^[[:xdigit:]]{24}$/
        end
      
      end

      resource :providers do
        desc 'returns all existent providers', {
          entity: V1::Entities::Provider,
          notes: <<-NOTES
            Returns all existent sessions paginated
          NOTES
        }
        params do
          #use :auth
          use :pagination
        end
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          providers = ::Provider.paginate(:page => page, :per_page => per_page)
          present providers, with: V1::Entities::Provider
        end
      end
    end
  end
end