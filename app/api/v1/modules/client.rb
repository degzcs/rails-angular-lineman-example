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
          optional :query_rucomid, type: String
        end

        params :id do
          requires :id, type: Integer, desc: 'User ID'
        end

        params :client do
          requires :client, type: Hash do
            optional  :rucom_id, type: Integer, desc: 'rucom_id', documentation: { example: 'Rock' }
            optional  :population_center_id, type: Integer, desc: 'population_center_id', documentation: { example: '1' }
            optional  :id_document_number, type: String, desc: 'id_document_number', documentation: { example: 'Rock' }
            optional  :id_document_type, type: String, desc: 'id_document_type', documentation: { example: 'Rock' }
            optional  :first_name, type: String, desc: 'first_name', documentation: { example: 'Rock' }
            optional  :last_name, type: String, desc: 'last_name', documentation: { example: 'Rock' }
            optional  :phone_number, type: String, desc: 'phone_number', documentation: { example: 'Rock' }
            optional  :address , type: String, desc: 'address', documentation: { example: 'Rock' }
            optional  :email , type: String, desc: 'email', documentation: { example: 'Rock' }
            optional  :client_type, type: String, desc: 'client_type', documentation: { example: 'Rock' }
            optional  :company_name, type: String, desc: 'client_type', documentation: { example: 'Rock' }
            optional  :nit_company_number, type: String, desc: 'client_type', documentation: { example: 'Rock' }
          end
        end

      end

      resource :clients do
        desc 'returns all existent clients', {
          entity: V1::Entities::Client,
          notes: <<-NOTES
            Returns all existent sessions paginated
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
          query_rucomid = params[:query_rucomid]
          #binding.pry
          if query_name
            clients = ::Client.order("id DESC").where("lower(first_name) LIKE :first_name OR lower(last_name) LIKE :last_name", 
              {first_name: "%#{query_name.downcase.gsub('%', '\%').gsub('_', '\_')}%", last_name: "%#{query_name.downcase.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
          elsif query_id
            clients = ::Client.order("id DESC").where("id_document_number LIKE :id_document_number", 
              {id_document_number: "%#{query_id.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
          elsif query_rucomid
            clients = ::Client.order("id DESC").where("rucom_id = :rucom_id", {rucom_id: query_rucomid}).paginate(:page => page, :per_page => per_page)
          else
            clients = ::Client.order("id DESC").paginate(:page => page, :per_page => per_page)
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
          client = ::Client.find(params[:id])
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
          use :client
        end
        post '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          #binding.pry
          content_type "text/json"
          
          client_params = params[:client]
          client = ::Client.new(params[:client])
          if client.save
            present client, with: V1::Entities::Client
          else
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
        end
        put '/:id', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          client = ::Client.find(params[:id])
          client_params = params[:client]
          client.update_attributes(params[:client])

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