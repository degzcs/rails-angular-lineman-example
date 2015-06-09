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
      end

      resource :clients do
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