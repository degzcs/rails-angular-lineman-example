class API < Grape::API
  prefix 'api'
  version 'v1', using: :path

  helpers do
    def current_user
      begin
        token = request.headers['Authorization'].split(' ').last
        payload = JWT.decode(token, Rails.application.secrets.secret_key_base)
        User.find(payload.first['user_id'])
      rescue
        false
      end
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end
  end

  mount V1::Modules::Purchase
  mount V1::Modules::User
  mount V1::Modules::AccessToken
  mount V1::Modules::Provider
  mount V1::Modules::Rucom

  # Adds the swagger documentation to your
  # api. You only need this once, not in
  # every sub module
  add_swagger_documentation(
    base_path: "/",
    hide_documentation_path: true,
    api_version: 'v1',
    markdown: true
  )
end
