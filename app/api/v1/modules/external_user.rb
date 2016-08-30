module V1
  module Modules
    class ExternalUser <  Grape::API

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

        params :external_user_query do
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

        params :external_user do
          optional :external_user, type: Hash do
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

      resource :external_users do
        desc 'returns all existent external_users', {
          entity: V1::Entities::ExternalUser,
          notes: <<-NOTES
            Returns all existent sessions paginated
          NOTES
        }
        params do
          use :pagination
          use :external_user_query
        end
        get '/', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          page = params[:page] || 1
          per_page = params[:per_page] || 10
          query_name = params[:query_name]
          query_id = params[:query_id]
          query_rucomid = params[:query_rucomid]
          #binding.pry
          external_users = if query_name
                                        ::User.external_users.order_by_id.find_by_name(query_name).paginate(:page => page, :per_page => per_page)
                                      elsif query_id
                                        ::User.external_users.order_by_id.find_by_document_number(query_id).paginate(:page => page, :per_page => per_page)
                                      elsif query_rucomid
                                        ::User.external_users.order_by_id.where("rucom_id = :rucom_id", {rucom_id: query_rucomid}).paginate(:page => page, :per_page => per_page)
                                      else
                                        ::User.authorized_providers.order_by_id.paginate(:page => page, :per_page => per_page)
                                      end
          #binding.pry
          header 'total_pages', external_users.total_pages.to_s
          present external_users, with: V1::Entities::ExternalUser
        end

        desc 'returns all external_user by external_user_types', {
          entity: V1::Entities::ExternalUser,
          notes: <<-NOTES
            Returns all external_user by external_user_types
          NOTES
        }
        params do
          # use :pagination
          # requires :external_user_types
        end
        get 'by_types'do
          # content_type "text/json"
          external_users = case params[:types]
                                when 'barequero_chatarrero'
                                 ::ExternalUser.barequeros_chatarreros
                                when 'beneficiarios_mineros'
                                  ::ExternalUser.mineros
                                when 'mineros'
                                  ::ExternalUser.mineros
                                when 'beneficiarios'
                                  ::ExternalUser.beneficiarios
                                when 'solicitantes'
                                  ::ExternalUser.solicitantes
                                when 'subcontratados'
                                  ::ExternalUser.subcontratados
                              end
          # binding.pry
          present external_users, with: V1::Entities::ExternalUser
        end

        desc 'returns one existent external_user by :id', {
          entity: V1::Entities::ExternalUser,
          notes: <<-NOTES
            Returns one existent external_user by :id
          NOTES
        }
        params do
          use :id
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          external_user = ::User.authorized_providers.find(params[:id])
          present external_user, with: V1::Entities::ExternalUser
        end

        # POST
        desc 'creates a new external_user', {
            entity: V1::Entities::ExternalUser,
            notes: <<-NOTE
              ### Description
              It creates a new external_user record and returns its current representation.
            NOTE
          }
        params do
          requires :external_user, type: Hash, desc: 'External user hash'
          optional :rucom_id, type: Integer, desc: 'Rucom id'
          optional :company, type: Hash, desc: 'Company'
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
          files =params[:external_user].slice(:files)[:files]
          # user files
          photo_file = files.select{|file| file['filename'] =~ /photo_file/}.first
          document_number_file = files.select{|file| file['filename'] =~ /document_number_file/}.first
          ext_user_mining_register_file = files.select{|file| file['filename'] =~ /ext_user_mining_register_file/}.first
          # company files
          mining_register_file = files.select{|file| file['filename'] =~ /mining_register_file/}.first
          rut_file = files.select{|file| file['filename'] =~ /rut_file/}.first
          chamber_of_commerce_file = files.select{|file| file['filename'] =~ /chamber_of_commerce_file/}.first

          # NOTE: This endpoint is about to be deprecated, but in order to continue its working, I update the document_number_file field name to id_document_file
          params[:external_user].except!(:files).merge!(id_document_file: document_number_file, photo_file: photo_file, mining_authorization_file: ext_user_mining_register_file)

          external_user_params = params[:external_user]
          arranged_params = V1::Helpers::UserHelper.rearrange_params(params[:external_user])
          external_user = ::User.new(arranged_params[:user_data])
          external_user.build_profile arranged_params[:profile_data]
          external_user.external = true

          # TODO: change this to user roles instead the external flag
          rucom = ::Rucom.find(params[:rucom_id])
          #If there is a company
          if params[:company]
            company = Company.new(params[:company].merge!(mining_register_file: mining_register_file, rut_file: rut_file, chamber_of_commerce_file: chamber_of_commerce_file))
            company.rucom = rucom
            external_user.build_office(name: "N/A", company: company)
          else
            external_user.personal_rucom = rucom
          end

          if external_user.save!
            present external_user, with: V1::Entities::ExternalUser
          else
            error!(external_user.errors.inspect, 400)
          end
        end

        # PUT
        desc 'updates a external_user', {
            entity: V1::Entities::ExternalUser,
            notes: <<-NOTE
              ### Description
              It updates a new external_user record and returns its current representation
            NOTE
          }
        params do
          requires :id
          use :external_user
          use :company
        end
        put '/:id', http_codes: [
          [200, "Successful"],
          [400, "Invalid parameter in entry"],
          [401, "Unauthorized"],
          [404, "Entry not found"],
        ]  do
          content_type "text/json"
          external_user = ::User.external_users.find(params[:id])
          external_user_params = params[:external_user]
          external_user.company.update_attributes(params[:company]) if params[:company]
          external_user.update_attributes(params[:external_user]) if params[:external_user]
          if external_user.save
            present external_user, with: V1::Entities::ExternalUser
          else
            error!(external_user.errors, 400)
          end
        end
      end
    end
  end
end