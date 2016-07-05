module V1
  module Modules
    class User <  Grape::API

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

        params :user_query do
          optional :query_name, type: String
          optional :query_id, type: String
          optional :query_rucomid, type: String
        end
      end

      # params :auth do
      #   requires :access_token, type: String, desc: 'Auth token', documentation: { example: '837f6b854fc7802c2800302e' }
      # end

      resource :users do
        desc 'returns all existent trazoro users', {
          entity: V1::Entities::User,
          notes: <<-NOTES
            Returns all existent users paginated
          NOTES
        }
        params do
          use :pagination
          use :user_query
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
            users = ::User.order("id DESC").where("lower(first_name) LIKE :first_name OR lower(last_name) LIKE :last_name",
              {first_name: "%#{query_name.downcase.gsub('%', '\%').gsub('_', '\_')}%", last_name: "%#{query_name.downcase.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
          elsif query_id
            users = ::User.order("id DESC").where("document_number LIKE :document_number",
              {document_number: "%#{query_id.gsub('%', '\%').gsub('_', '\_')}%"}).paginate(:page => page, :per_page => per_page)
          elsif query_rucomid
            users = ::User.order("id DESC").where("rucom_id = :rucom_id", {rucom_id: query_rucomid}).paginate(:page => page, :per_page => per_page)
          else
            users = ::User.order("id DESC").paginate(:page => page, :per_page => per_page)
          end
          #binding.pry
          header 'total_pages', users.total_pages.to_s
          present users, with: V1::Entities::User
        end

        desc 'Returns me', {
            notes: <<-NOTE
              ### Description
              It returns the logged user. \n

              ### Example successful response

                  {
                    "id": "1",
                    "name": "Lourdez Astre",
                    "first_name": "Lourdez",
                    "last_name": "Astre",
                    "email": "lourdezastre@test.com",
                  }
            NOTE
          }
        get :me do
         # 'grape transformation' gem works the same way to :type paramater in present method?
         present current_user, with: V1::Entities::User
        end

        desc 'returns one existent user by :id', {
          entity: V1::Entities::User,
          notes: <<-NOTES
            Returns one existent user by :id
          NOTES
        }
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        get '/:id', http_codes: [ [200, "Successful"], [401, "Unauthorized"] ] do
          content_type "text/json"
          user = ::User.find(params[:id])
          present user, with: V1::Entities::User
        end

        desc 'Update the current user', {
            notes: <<-NOTE
              ### Description
              Update the current user. \n
              It returns the logged user. \n

              ### Example successful response

                  {
                    "id": "1",
                    "name": "Lourdez Astre",
                    "first_name": "Lourdez",
                    "last_name": "Astre",
                    "email": "lourdezastre@test.com",
                  }
            NOTE
          }
        params do
           requires :user, type: Hash
        end
        put '/', http_codes: [
            [200, "Successful"],
            [400, "Invalid parameter"],
            [401, "Unauthorized"],
            [404, "Entry not found"],
          ] do
              arranged_params = arrange(params[:user])
              current_user.update()
              present current_user, with: V1::Entities::User
        end
      end
    end
  end
end