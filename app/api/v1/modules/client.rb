module V1
  module Modules
    class Client <  Grape::API

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

        params :client_query do
          optional :query_name, type: String
          optional :query_id, type: String
        end
      end


      resource :clients do
        #GET
          desc 'returns all existent cleints', {
          entity: V1::Entities::ExternalUser,
          notes: <<-NOTES
            Returns all existent cleints paginated
          NOTES
        }
        params do
          use :pagination
          use :client_query
        end
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          query_name = params[:query_name]
          query_id = params[:query_id]
          #binding.pry
          clients =  if query_name
                            ::User.clients.order_by_id.find_by_name(query_name).paginate(:page => page, :per_page => per_page)
                          elsif query_id
                            ::User.clients.order_by_id.find_by_document_number(query_id).paginate(:page => page, :per_page => per_page)
                          else
                            ::User.clients.order_by_id.paginate(:page => page, :per_page => per_page)
                          end
          #binding.pry
          header 'total_pages', clients.total_pages.to_s
          present clients, with: V1::Entities::Client
        end

        # POST
        desc 'creates a new client', {
            entity: V1::Entities::Client,
            notes: <<-NOTE
              ### Description
              It creates a new client record and returns its current representation.
            NOTE
          }
        params do
        end
        post '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
           #binding.pry
          content_type "text/json"

          # update params
          files =params[:client].slice(:files)[:files]
          document_number_file = files.select{|file| file['filename'] =~ /document_number_file/}.first
          # mining_register_file = files.select{|file| file['filename'] =~ /mining_register_file/}.first
          rut_file = files.select{|file| file['filename'] =~ /rut_file/}.first
          photo_file = files.select{|file| file['filename'] =~ /photo_file/}.first
          params[:client].except!(:files).merge!(document_number_file: document_number_file, rut_file: rut_file, photo_file: photo_file)

          client_params = params[:client]
          client = ::User.new(params[:client])
          client.external = true
          client.build_company(params[:company]) if params[:company]


          if params[:activity].present?
            rucom = ::Rucom.create_trazoro(provider_type: params[:activity])
            client.personal_rucom = rucom
          end

          if client.save
            present client, with: V1::Entities::Client
          else

            error!(client.errors.inspect, 400)
          end
          Rails.logger.info(client.errors.inspect)
        end
      end

    end
  end
end