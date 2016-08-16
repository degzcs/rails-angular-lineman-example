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
      end

      resource :autorized_providers do
        #
        # GET by id_number
        #
        desc 'returns the specificaded provider by id_number',
          { entity: V1::Entities::AuthorizedProvider,
            notes: <<-NOTES
                    Returns the specificaded provider by id_number  otherwise it returns a message
              NOTES
          }

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
            error!({ error: "unexpected error", detail: sync.response[:errors] }, 409)
          end
        end
      end
    end
  end
end
