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

        params :profile do
          optional :nit_number, type: String, desc: 'nit_number', documentation: { example: '123456789' }
          optional :first_name, type: String, desc: 'first name', documentation: { example: 'Elquin' }
          optional :last_name, type: String, desc: 'last name', documentation: { example: 'Ceagnero' }
          optional :city_id, type: String, desc: 'city', documentation: { example: '1' }
          optional :address, type: String, desc: 'address', documentation: { example: 'Rock' }
          optional :phone_number, type: String, desc: 'phone_number', documentation: { example: '3004563456' }
        end

        params :pagination do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end

        params :rucom do
          optional :rucom_number, type: Integer
        end

        params :authorized_provider do
          optional :email, type: String, desc: 'email', documentation: { example: 'Rock' }
        end

        params :files do
          optional :rut_file, type: File, desc: 'rut_file', documentation: { example: '...' }
          optional :photo_file, type: File, desc: 'photo_file', documentation: { example: '...' }
          optional :signature_picture_file, type: File, desc: 'signature_picture_file', documentation: { example: '...' }
        end
      end

      resource :authorized_providers do
        #
        # GET all
        #
        desc 'returns all authorized providers',
          entity: V1::Entities::AuthorizedProvider,
          notes: <<-NOTES
            Returns all existent sessions paginated
          NOTES

        params do
          use :pagination
          # use :authorized_provider_query
        end
        get '/', http_codes: [[200, 'Successful'], [401, 'Unauthorized']] do
          content_type 'text/json'
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          query_name = params[:query_name]
          query_id = params[:query_id]
          query_rucomid = params[:query_rucomid]
          authorized_providers =
            if query_name
              ::User.authorized_providers.completed.order_by_id.find_by_name(query_name).paginate(page: page, per_page: per_page)
            elsif query_id
              ::User.authorized_providers.completed.order_by_id.find_by_document_number(query_id).paginate(page: page, per_page: per_page)
            elsif query_rucomid
              ::User.authorized_providers.completed.order_by_id.where('rucom_id = :rucom_id', rucom_id: query_rucomid).paginate(page: page, per_page: per_page)
            else
              ::User.authorized_providers.completed.order_by_id.paginate(page: page, per_page: per_page)
            end
          # binding.pry
          header 'total_pages', authorized_providers.total_pages.to_s
          present authorized_providers, with: V1::Entities::AuthorizedProvider
        end

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
        # GET by id
        #
        desc 'returns an authorized provider by :id',
          entity: V1::Entities::AuthorizedProvider,
          notes: <<-NOTES
            Returns an authorized provider by :id
          NOTES

        params do
          use :id
        end
        get '/:id', http_codes: [[200, 'Successful'], [401, 'Unauthorized']] do
          content_type 'text/json'
          authorized_provider = ::User.authorized_providers.find(params[:id])
          present authorized_provider, with: V1::Entities::AuthorizedProvider
        end

        #
        # PUT by id
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
          use :profile
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
          if authorized_provider.present?
            formatted_params = V1::Helpers::UserHelper.authorized_provider_params(params)
            service = ::AuthorizedProvider::Registration.new
            service.call(authorized_provider: authorized_provider, formatted_params: formatted_params, current_user: current_user)
            if service.response[:success]
              present authorized_provider, with: V1::Entities::AuthorizedProvider
            else
              error!(service.response[:errors], 409)
            end
          end
        end

        #
        # PUT update_basic_info by id
        #
        desc 'update basic informationn Autorized Provider',
             entity: V1::Entities::AuthorizedProvider,
             notes: <<-NOTE
                          ### Description
                          It updates an Autorized Provider
                     NOTE

        params do
          requires :id
          use :authorized_provider
          use :profile
        end
        put '/update_basic_info/:id', http_codes: [
          [200, 'Successful'],
          [400, 'Invalid parameter in entry'],
          [401, 'Unauthorized'],
          [404, 'Entry not found']
        ] do
          content_type 'text/json'
          authorized_provider = ::User.find(params[:id])
          if authorized_provider.present?
            service = ::AuthorizedProvider::UpdateBasicInfo.new
            service.call(authorized_provider: authorized_provider, params: params, current_user: current_user)
            if service.response[:success]
              present authorized_provider, with: V1::Entities::AuthorizedProvider
            else
              error!(service.response[:errors], 409)
            end
          end
        end
      end #resource
    end #class
  end #module
end # module
