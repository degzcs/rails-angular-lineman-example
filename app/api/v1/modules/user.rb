module V1
  module Modules
    class User <  Grape::API

     before_validation do
        authenticate!
      end

      format :json
      content_type :json, 'application/json'

        # params :auth do
        #   requires :access_token, type: String, desc: 'Auth token', documentation: { example: '837f6b854fc7802c2800302e' }
        # end

      resource :users do
        desc 'Retuns all users'
        get :all do
          ::User.all.to_a
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
              current_user.update(params[:user])
              present current_user, with: V1::Entities::User
        end
      end
    end
  end
end