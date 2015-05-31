module V1
  module Modules
    class Rucom <  Grape::API

      before_validation do
        authenticate!
      end
      default_error_status 400


      format :json
      content_type :json, 'application/json'

      helpers do

        params :pagination do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end

        params :rucom_query do
          optional :query_rucom_number, type: String
          optional :query_provtype, type: String
          optional :query_name, type: String
        end

        params :id do
          requires :id, type: Integer, desc: 'Rucom ID'
        end

      end

      resource :rucoms do
        desc 'returns all existent rucoms matching the param rucom_query if provided', {
          entity: V1::Entities::Rucom,
          notes: <<-NOTES
            Returns all existent rucoms paginated
          NOTES
        }
        params do
          use :pagination
          use :rucom_query
        end
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          query_rucom_number = params[:query_rucom_number]
          query_name = params[:query_name]
          query_provtype = params[:query_provtype]

          if query_name
            rucoms = ::Rucom.order("id DESC").where("lower(name) LIKE :name",
              {name: "%#{query_name.downcase.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
          elsif query_rucom_number
            rucoms = ::Rucom.where("num_rucom LIKE :num_rucom OR rucom_record LIKE :num_rucom OR subcontract_number LIKE :num_rucom",
            {num_rucom: "%#{query_rucom_number.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
          elsif query_provtype
            rucoms = ::Rucom.where("provider_type LIKE :provider_type",
              {provider_type: "%#{query_provtype.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
            header 'total_pages', rucoms.total_pages.to_s
          else
            rucoms = ::Rucom.paginate(:page => page, :per_page => per_page)
            header 'total_pages', rucoms.total_pages.to_s
          end
          present rucoms, with: V1::Entities::Rucom
        end
        desc 'returns one existent rucom registry by :id', {
          entity: V1::Entities::Rucom,
          notes: <<-NOTES
            Returns one existent rucoms by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          rucom = ::Rucom.find(params[:id])
          present rucom, with: V1::Entities::Rucom
        end
        desc 'returns one existent rucom registry by :id', {
          entity: V1::Entities::Rucom,
          notes: <<-NOTES
            Returns one existent rucoms by :id
          NOTES
        }
        params do
          use :id
        end

        get '/:id/check_if_available', http_codes: [ [200, "Successful"], [400, "Unauthorized"] ] do
          content_type "text/json"
          rucom = ::Rucom.find(params[:id])
          if rucom.rucomeable_id
            error!  "Este rucom no esta disponible"
          else
            present rucom, with: V1::Entities::Rucom
          end
        end
      end
    end
  end
end