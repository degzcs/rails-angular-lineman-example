module V1
  module Modules
    class AccessToken < Grape::API

      format :json
      content_type :json, 'application/json'

      resource :auth do
        desc 'Returns a token by authenticating user email and password credentials', {
            entity: V1::Entities::AccessToken,
            notes: <<-NOTE
              ### Description
              It creates a new login the user and returns its current representation with a JWT. \n

              ### Example successful response

                  {
                    "access_token": "the_most_secure_token",
                    "expires_in": "2014-06-09T13:50:52-05:00"
                  }
            NOTE
          }
        params do
          requires :email, type: String
          requires :password, type: String
        end
        post 'login' do
          user = ::User.where(email: params[:email]).last
          user.authenticate(params[:password])

          {
            access_token: user.create_token,
            expires_in: Time.now.tomorrow
          }
        end

      end
    end
  end
end
