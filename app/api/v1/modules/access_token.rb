module V1
  module Modules
    class AccessToken < Grape::API

      format :json
      content_type :json, 'application/json'

      #
      # Login
      #

      resource :auth do
        desc 'Returns a token by authenticating user email and password credentials', {
            entity: V1::Entities::AccessToken,
            notes: <<-NOTE
              ### Description
              It login the user and returns its current representation with a JWT. \n

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

      #
      # Forgot password?
      #

      desc 'Returns a token by authenticating user email and sending a reset token to the user email', {
            entity: V1::Entities::AccessToken,
            notes: <<-NOTE
              ### Description
              It create a reset_token and sent it to user's email to reset password and returns its current representation with a JWT. \n

              ### Example successful response

                  {
                    "access_token": "the_most_secure_token",
                    "expires_in": "2014-06-09T13:50:52-05:00"
                  }
            NOTE
          }
        params do
          requires :email, type: String
        end
        post 'forgot_password' do
          user = ::User.where(email: params[:email]).last
          UserResetPassword.new(user).process!
          {
            access_token: user.create_token,
            expires_in: Time.now.tomorrow
          }
        end

      #
      #  check reset token to change password
      #

      desc 'it check if the reset_token is correct to change the password ', {
            entity: V1::Entities::AccessToken,
            notes: <<-NOTE
              ### Description
              It check if the reset_token is correct to change the password and returns its current representation with a JWT. \n

              ### Example successful response

                  {
                    "access_token": "the_most_secure_token",
                    "expires_in": "2014-06-09T13:50:52-05:00"
                  }
            NOTE
          }
        params do
          requires :email, type: String
          requires :token, type: String
        end
        get 'confirmation' do
          user = ::User.where(email: params[:email]).last
          if UserResetPassword.new(user).can_change_password_with_this_token?(params[:token])
            {
              access_token: user.create_token,
              expires_in: Time.now.tomorrow
            }
          else
            {message: 'Usted no puede cambiar la contrasena de este usuario!!'}
          end
        end

     end
    end
  end
end
