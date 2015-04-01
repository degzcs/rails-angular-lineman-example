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

        params :id do
          requires :id, type: Integer, desc: 'User ID'
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
          use :pagination
        end
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          providers = ::Provider.paginate(:page => page, :per_page => per_page)
          present providers, with: V1::Entities::Provider
        end
        desc 'returns one existent provider by :id', {
          entity: V1::Entities::Provider,
          notes: <<-NOTES
            Returns one existent provider by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          provider = ::Provider.find(params[:id])
          present provider, with: V1::Entities::Provider
        end
        # POST
        desc 'creates a new provider', {
            entity: V1::Entities::Provider,
            notes: <<-NOTE
              ### Description
              It creates a new provider record and returns its current representation.
            NOTE
          }
        params do
          requires :rucom_id, type: Integer
          requires :provider, type: Hash
          optional :company_info , type: Hash
        end
        post '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          rucom = ::Rucom.find(params[:rucom_id])
          provider_params = params[:provider]
          provider_params[:rucom] = rucom
          provider = ::Provider.new(params[:provider])
          provider.build_company_info(params[:company_info]) if params[:company_info]
          if provider.save
            present provider, with: V1::Entities::Provider
          else
            error!(entry.errors, 400)
          end
        end
        # PUT
        desc 'updates a provider', {
            entity: V1::Entities::Provider,
            notes: <<-NOTE
              ### Description
              It updates a new provider record and returns its current representation
            NOTE
          }
        params do
          requires :id
          requires :provider, type: Hash
        end
        put '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          provider = ::Provider.find(params[:id])
          provider.update_attributes(params[:provider])
          if provider.save
            present provider, with: V1::Entities::Provider
          else
            error!(entry.errors, 400)
          end
        end
      end
    end
  end
end