module V1
  module Modules
    # AuthorizedProviders end point to returns the provider by id_number
    class AuthorizedProviders < Grape::API
      before_validation do
        authenticate!
      end

      format :json
      content_type :json, 'application/json'

      helpers do
        params :id_number do
          requires :id_number, type: String, desc: 'ID Number from Authorized Provider'
        end

        params :rol_name do
          requires :rol_name, type: String, desc: 'Role Name is send it by default as Barequero'
        end

        params :id_type do
          requires :id_type, type: String, desc: 'ID Type is send it by default as CEDULA'
        end

        params :id do
          requires :id, type: Integer, desc: 'User ID'
        end

        # params :profile do
          # optional :profile, type: Hash do
          #   optional :nit_number, type: String, desc: 'nit_number', documentation: { example: 'Rock' }
          #   optional :name, type: String, desc: 'name', documentation: { example: 'Rock' }
          #   optional :city, type: String, desc: 'city', documentation: { example: 'Rock' }
          #   optional :state, type: String, desc: 'state', documentation: { example: 'Rock' }
          #   optional :country, type: String, desc: 'country', documentation: { example: 'Rock' }
          #   optional :legal_representative, type: String, desc: 'legal_representative', documentation: { example: 'Rock' }
          #   optional :id_type_legal_rep, type: String, desc: 'id_type_legal_rep', documentation: { example: 'Rock' }
          #   optional :id_number_legal_rep, type: String, desc: 'id_number_legal_rep', documentation: { example: 'Rock' }
          #   optional :phone_number, type: String, desc: 'phone_number', documentation: { example: 'Rock' }
          #   optional :id_document_file, type: File, desc: 'id_document_file', documentation: { example: '...' }
          #   optional :mining_authorization_file, type: File, desc: 'mining_authorization_file', documentation: { example: '...' }
          #   optional :photo_file, type: File, desc: 'photo_file', documentation: { example: '...' }
          # end
        # end

        params :authorized_provider do
          optional :authorized_provider, type: Hash do
            optional :rucom_id, type: Integer, desc: 'rucom_id', documentation: { example: 'Rock' }
            optional :document_number, type: String, desc: 'document_number', documentation: { example: 'Rock' }
            optional :first_name, type: String, desc: 'first_name', documentation: { example: 'Rock' }
            optional :last_name, type: String, desc: 'last_name', documentation: { example: 'Rock' }
            optional :phone_number, type: String, desc: 'phone_number', documentation: { example: 'Rock' }
            optional :address, type: String, desc: 'address', documentation: { example: 'Rock' }
            optional :email, type: String, desc: 'email', documentation: { example: 'Rock' }
          end
        end

        params :rucom do
          optional :rucom, type: Hash do
            optional :rucom_id, type: Integer, desc: 'rucom_id', documentation: { example: 'Rock' }
            optional :rucom_number, type: String, desc: 'rucom_number', documentation: { example: 'Rock' }
          end
        end

        params :files do
          optional :files, type: Hash do
            optional :document_number_file, type: File, desc: 'id_document_file', documentation: { example: '...' }
            optional :mining_register_file, type: File, desc: 'mining_authorization_file', documentation: { example: '...' }
            optional :photo_file, type: File, desc: 'photo_file', documentation: { example: '...' }
          end
        end
      end




      resource :autorized_providers do
        #
        # GET by id_number
        #
        desc 'returns the specificaded provider by id_number',
             entity: V1::Entities::AuthorizedProvider,
             notes: <<-NOTES
                      Returns the specificaded provider by id_number  otherwise it returns a message
                    NOTES
        params do
          use :id_number
          use :rol_name
          use :id_type
        end

        get '/by_id_number', http_codes: [[200, 'Successful'], [401, 'Unauthorized']] do
          content_type 'text/json'
          options_from_view = { rol_name: params['rol_name'], id_type: params['id_type'], id_number: params['id_number'] }
          sync = RucomServices::Synchronize.new(options_from_view).call
          if sync.success
            present sync.user, with: V1::Entities::AuthorizedProvider
          else
            error!({ error: 'unexpected error', detail: sync.response[:errors] }, 409)
          end
        end

        #
        # PUT -> Update by user id
        #
        desc 'updates an Autorized Provider',
             entity: V1::Entities::AuthorizedProvider,
             notes: <<-NOTE
                          ### Description
                          It updates an user who is an Authorized provider and returns its current representation
                     NOTE
        params do
          requires :id
          use :authorized_provider
          # use :profile
          use :rucom
        end
        put '/:id', http_codes: [
          [200, 'Successful'],
          [400, 'Invalid parameter in entry'],
          [401, 'Unauthorized'],
          [404, 'Entry not found']
        ] do
          content_type 'text/json'
          authorized_provider = ::User.find(params[:id])
          p 'antes de ser modificados params y add files'
          p params
          format_params = V1::Helpers::UserHelper.format_params_files(params)
          p 'despues de ser modificados  params y add files'
          p format_params
          authorized_provider.update_attributes(format_params['authorized_provider']) if format_params['authorized_provider'] && authorized_provider.present?
          authorized_provider.profile.update_attributes(format_params['profile']) if format_params['profile']
          authorized_provider.rucom.update_attributes(format_params['rucom']) if format_params['rucom']
          if authorized_provider.save
            present authorized_provider, with: V1::Entities::AuthorizedProvider
          else
            error!(authorized_provider.errors, 400)
          end
        end
      end
    end
  end
end
