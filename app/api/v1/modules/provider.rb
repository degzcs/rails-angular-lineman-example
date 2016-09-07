module V1
  module Modules
    class Provider <  Grape::API

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

        params :provider_query do
          optional :query_name, type: String
          optional :query_id, type: String
          optional :query_rucomid, type: String
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

        params :provider do
          optional :provider, type: Hash do
            optional  :rucom_id, type: Integer, desc: 'rucom_id', documentation: { example: 'Rock' }
            optional  :document_number, type: String, desc: 'document_number', documentation: { example: 'Rock' }
            optional  :first_name, type: String, desc: 'first_name', documentation: { example: 'Rock' }
            optional  :last_name, type: String, desc: 'last_name', documentation: { example: 'Rock' }
            optional  :phone_number, type: String, desc: 'phone_number', documentation: { example: 'Rock' }
            optional  :address , type: String, desc: 'address', documentation: { example: 'Rock' }
            optional  :email , type: String, desc: 'email', documentation: { example: 'Rock' }
          end
        end

      end

      resource :providers do
        desc 'returns all existent providers', {
          entity: V1::Entities::Provider,
          notes: <<-NOTES
            Returns all existent sessions paginated
          NOTES
        }
        params do
          use :pagination
          use :provider_query
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
            providers = ::User.providers.order("id DESC").where("lower(first_name) LIKE :first_name OR lower(last_name) LIKE :last_name",
              {first_name: "%#{query_name.downcase.gsub('%', '\%').gsub('_', '\_')}%", last_name: "%#{query_name.downcase.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
          elsif query_id
            providers = ::User.providers.order("id DESC").where("document_number LIKE :document_number",
              {document_number: "%#{query_id.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
          elsif query_rucomid
            providers = ::User.providers.order("id DESC").where("rucom_id = :rucom_id", {rucom_id: query_rucomid}).paginate(:page => page, :per_page => per_page)
          else
            providers = ::User.providers.order("id DESC").paginate(:page => page, :per_page => per_page)
          end
          #binding.pry
          header 'total_pages', providers.total_pages.to_s
          present providers, with: V1::Entities::Provider
        end

        desc 'returns all provider by provider_types', {
          entity: V1::Entities::Provider,
          notes: <<-NOTES
            Returns all provider by provider_types
          NOTES
        }
        params do
          # use :pagination
          # requires :provider_types
        end
        get 'by_types'do
          # content_type "text/json"
          providers = case params[:types]
                                when 'barequero_chatarrero'
                                 ::User.providers.barequeros_chatarreros
                                when 'beneficiarios_mineros'
                                  ::User.providers.mineros
                                when 'mineros'
                                  ::User.providers.mineros
                                when 'beneficiarios'
                                  ::User.providers.beneficiarios
                                when 'solicitantes'
                                  ::User.providers.solicitantes
                                when 'subcontratados'
                                  ::User.providers.subcontratados
                                when 'casas_compra_venta'
                                  ::User.providers.casas_compra_venta
                              end
          # binding.pry
          present providers, with: V1::Entities::Provider
        end

        desc 'returns one existent provider by :id', {
          entity: V1::Entities::Provider,
          notes: <<-NOTES
            Returns one existent provider by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          provider = ::User.providers.find(params[:id])
          present provider, with: V1::Entities::Provider
        end

        # POST
        desc 'creates a new provider', {
            entity: V1::Entities::Provider,
            notes: <<-NOTE
              ### Description
              It creates a new provider record and returns its current representation.
            NOTE
          }
        params do
          requires :provider, type: Hash, desc: 'External user hash'
          optional :rucom_id, type: Integer, desc: 'Rucom id'
          optional :company, type: Hash, desc: 'Company'
        end
        post '/', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do

          content_type "text/json"

          # update params
          files =params[:provider].slice(:files)[:files]
          # files = params[:provider][:files]
          document_number_file = files.select{|file| file['filename'] =~ /document_number_file/}.first
          mining_register_file = files.select{|file| file['filename'] =~ /mining_register_file/}.first
          rut_file = files.select{|file| file['filename'] =~ /rut_file/}.first
          # TODO: save this value in the correct model
          # chamber_commerce_file = files.select{|file| file['filename'] =~ /chamber_commerce_file/}.first
          photo_file = files.select{|file| file['filename'] =~ /photo_file/}.first
          params[:provider].except!(:files).merge!(document_number_file: document_number_file, mining_register_file: mining_register_file, rut_file: rut_file, photo_file: photo_file)
          provider_params = params[:provider]
          provider = ::User.new(params[:provider])
          provider.build_company(params[:company]) if params[:company]

          if params[:rucom_id]
            rucom = ::Rucom.find(params[:rucom_id]) if params[:rucom_id]
            provider.personal_rucom = rucom
          end



          if provider.save
            present provider, with: V1::Entities::Provider
          else
            #binding.pry

            error!(provider.errors.inspect, 400)
          end
          Rails.logger.info(provider.errors.inspect)
        end
        # PUT
        desc 'updates a provider', {
            entity: V1::Entities::Provider,
            notes: <<-NOTE
              ### Description
              It updates a new provider record and returns its current representation
            NOTE
          }
        params do
          requires :id
          use :provider
          use :company
        end
        put '/:id', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          #binding.pry
          content_type "text/json"
          provider = ::User.providers.find(params[:id])
          provider_params = params[:provider]
          provider.company.update_attributes(params[:company]) if params[:company]
          provider.update_attributes(params[:provider]) if params[:provider]
          if provider.save
            present provider, with: V1::Entities::Provider
          else
            error!(provider.errors, 400)
          end
        end
      end
    end
  end
end