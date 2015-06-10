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

        params :id do
          requires :id, type: Integer, desc: 'External User ID'
        end

        params :company do
          optional :company, type: Hash do
            optional  :nit_number, type: String, desc: 'nit_number', documentation: { example: 'Rock' }
            optional  :name, type: String, desc: 'name', documentation: { example: 'Rock' }
            optional  :city, type: String, desc: 'city', documentation: { example: 'Rock' }
            optional  :state, type: String, desc: 'state', documentation: { example: 'Rock' }
            optional  :country , type: String, desc: 'country', documentation: { example: 'Rock' }
            optional  :legal_representative, type: String, desc: 'legal_representative', documentation: { example: 'Rock' }
            optional  :id_type_legal_rep, type: String, desc: 'id_type_legal_rep', documentation: { example: 'Rock' }
            optional  :id_number_legal_rep, type: String, desc: 'id_number_legal_rep', documentation: { example: 'Rock' }
            optional  :email, type: String, desc: 'email', documentation: { example: 'Rock' }
            optional  :phone_number, type: String, desc: 'phone_number', documentation: { example: 'Rock' }
          end
        end

        params :client do
          optional :client, type: Hash do
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


      resource :clients do
        #GET
          desc 'returns all existent clients', {
          entity: V1::Entities::Client,
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

       desc 'returns one existent client by :id', {
          entity: V1::Entities::Client,
          notes: <<-NOTES
            Returns one existent client by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          client = ::User.clients.find(params[:id])
          present client, with: V1::Entities::Client
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

          if params[:company] .present? &&  params[:activity].present?
            fake_rucom = ::Rucom.create_trazoro(provider_type: params[:activity])
            company_with_fake_rucom = Company.new(params[:company].merge(rucom: fake_rucom))
            company_with_fake_rucom.save(validate: false) # NOTE: we have to put this because the client asked us to don't use validations when the users are clients
            office_for_company_with_fake_rucom = Office.create(name: 'N/A', company: company_with_fake_rucom)
            client.office = office_for_company_with_fake_rucom
          end

          if params[:activity].present? && params[:company].try(:empty?)
            rucom = ::Rucom.create_trazoro(provider_type: params[:activity])
            client.personal_rucom = rucom
          end

          if client.save
            present client, with: V1::Entities::Client
          else
            puts client.errors.inspect
           error!(client.errors.inspect, 400)
          end
          Rails.logger.info(client.errors.inspect)
        end

        # PUT
        desc 'updates a client', {
            entity: V1::Entities::Client,
            notes: <<-NOTE
              ### Description
              It updates a new client record and returns its current representation
            NOTE
          }
        params do
          requires :id
          use :client
          use :company
        end
        put '/:id', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          client = ::User.clients.find(params[:id])
          client_params = params[:client]
          client.company.update_attributes(params[:company]) if params[:company]
          client.update_attributes(params[:client]) if params[:client]

          if client.save
            present client, with: V1::Entities::Client
          else
            error!(client.errors, 400)
          end
        end

      end
    end
  end
end