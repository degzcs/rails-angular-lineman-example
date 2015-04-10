module V1
  module Modules
    class Courier <  Grape::API

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

        params :id_document_number do
          optional :id_document_number, type: String, desc: 'User ID Document Number'
        end

        params :courier do
          requires :courier, type: Hash do
            optional  :id_document_number, type: String, desc: 'document_number', documentation: { example: '120932434' }
            optional  :id_document_type, type: String, desc: 'id document type', documentation: { example: 'CC | CE' }
            optional  :first_name, type: String, desc: 'first_name', documentation: { example: 'Rock' }
            optional  :last_name, type: String, desc: 'last_name', documentation: { example: 'Rock' }
            optional  :phone_number, type: String, desc: 'phone_number', documentation: { example: 'Rock' }
            optional  :address , type: String, desc: 'address', documentation: { example: 'Rock' }
            optional  :nit_company_number, type: String, desc: "Courier company's id number", documentation: { example: "1968353479" }
            optional  :company_name, type: String, desc: "Name of the company the courier belongs to", documentation: { example: "TrazOro" }
          end
        end

      end

      resource :couriers do
        desc 'returns all existent couriers paginated or those matching the id_document_number (if given)', {
          entity: V1::Entities::Courier,
          notes: <<-NOTES
            Returns all existent couriers paginated or those matching the id_document_number (if given)
          NOTES
        }
        params do
          use :pagination
          use :id_document_number
        end
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          id_document_number = params[:id_document_number]
          if id_document_number
            couriers = ::Courier.where("id_document_number = :id_document_number", 
              {id_document_number: id_document_number})            
          else
            couriers = ::Courier.paginate(:page => page, :per_page => per_page)
            header 'total_pages', couriers.total_pages.to_s
          end
          present couriers, with: V1::Entities::Courier
        end
        desc 'returns one existent courier by :id', {
          entity: V1::Entities::Courier,
          notes: <<-NOTES
            Returns one existent courier by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          courier = ::Courier.find(params[:id])
          present courier, with: V1::Entities::Courier
        end
        # POST
        desc 'creates a new courier', {
            entity: V1::Entities::Courier,
            notes: <<-NOTE
              ### Description
              It creates a new courier record and returns its current representation.
            NOTE
          }
        params do
          use :courier
        end
        post '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          courier_params = params[:courier]
          courier = ::Courier.new(params[:courier])          
          if courier.save
            present courier, with: V1::Entities::Courier
          else
            error!(courier.errors.inspect, 400)
          end
          Rails.logger.info(courier.errors.inspect)
        end
        # PUT
        desc 'updates a courier', {
            entity: V1::Entities::Courier,
            notes: <<-NOTE
              ### Description
              It updates a new courier record and returns its current representation
            NOTE
          }
        params do
          requires :id
          use :courier          
        end
        put '/:id', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          courier = ::Courier.find(params[:id])
          courier_params = params[:courier]
          courier.update_attributes(params[:courier])

          if courier.save
            present courier, with: V1::Entities::Courier
          else
            error!(courier.errors, 400)
          end
        end
      end
    end
  end
end