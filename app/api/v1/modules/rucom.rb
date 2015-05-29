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
          optional :rucom_query, type: String
          optional :query_provtype, type: String
          optional :name_query, type: String
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
          rucom_query = params[:rucom_query]
          name_query = params[:name_query]
          query_provtype = params[:query_provtype]
          if rucom_query and name_query
            rucoms = ::Rucom.where("num_rucom LIKE :num_rucom AND lower(name) LIKE :rucom_name OR rucom_record LIKE :rucom_record AND lower(name) LIKE :rucom_name OR subcontract_number LIKE :subc_num AND lower(name) LIKE :rucom_name", 
              {num_rucom: "%#{rucom_query.gsub('%', '\%').gsub('_', '\_')}%", rucom_record: "%#{rucom_query.gsub('%', '\%').gsub('_', '\_')}%", subc_num: "%#{rucom_query.gsub('%', '\%').gsub('_', '\_')}%", rucom_name: "%#{name_query.downcase.gsub('%', '\%').gsub('_', '\_')}%"})
            #rucoms = rucoms.paginate(:page => page, :per_page => per_page)
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
          if rucom.trazoro_user_id
            error!  "Este rucom no esta disponible"
          else
            present rucom, with: V1::Entities::Rucom
          end
        end
      end
    end
  end
end