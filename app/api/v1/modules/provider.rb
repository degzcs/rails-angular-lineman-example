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

        params :company_info do
          optional :company_info, type: Hash do
            optional  :nit_number, type: String, desc: 'nit_number', documentation: { example: 'Rock' }
            optional  :name, type: String, desc: 'name', documentation: { example: 'Rock' }
            optional  :city, type: String, desc: 'city', documentation: { example: 'Rock' }
            optional  :state, type: String, desc: 'state', documentation: { example: 'Rock' }
            optional  :country , type: String, desc: 'country', documentation: { example: 'Rock' }
            optional  :legal_representative, type: String, desc: 'legal_representative', documentation: { example: 'Rock' }
            optional  :id_type_legal_rep, type: String, desc: 'id_type_legal_rep', documentation: { example: 'Rock' }
            optional  :email, type: String, desc: 'email', documentation: { example: 'Rock' }
            optional  :phone_number, type: String, desc: 'phone_number', documentation: { example: 'Rock' }
          end
        end

        params :provider do
          requires :provider, type: Hash do
            optional  :rucom_id, type: Integer, desc: 'rucom_id', documentation: { example: 'Rock' }
            optional  :population_center_id, type: Integer, desc: 'population_center_id', documentation: { example: '1' }
            optional  :document_number, type: String, desc: 'document_number', documentation: { example: 'Rock' }
            optional  :first_name, type: String, desc: 'first_name', documentation: { example: 'Rock' }
            optional  :last_name, type: String, desc: 'last_name', documentation: { example: 'Rock' }
            optional  :phone_number, type: String, desc: 'phone_number', documentation: { example: 'Rock' }
            optional  :address , type: String, desc: 'address', documentation: { example: 'Rock' }
            optional  :email , type: String, desc: 'email', documentation: { example: 'Rock' }
          end
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
          header 'total_pages', providers.total_pages.to_s
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
          use :provider
          use :company_info
        end
        post '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          provider_params = params[:provider]
          provider = ::Provider.new(params[:provider])
          provider.build_company_info(params[:company_info]) if params[:company_info]
          if provider.save
            present provider, with: V1::Entities::Provider
          else
            error!(provider.errors.inspect, 400)
          end
          Rails.logger.info(provider.errors.inspect)
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
          use :provider
          use :company_info
        end
        put '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          provider = ::Provider.find(params[:id])
          provider_params = params[:provider]
          provider.company_info.update_attributes(params[:company_info]) if params[:company_info]
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