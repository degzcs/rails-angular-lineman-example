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
  mount V1::Modules::ExternalUser
  mount V1::Modules::Provider
  mount V1::Modules::Rucom
  mount V1::Modules::State
  mount V1::Modules::City
  mount V1::Modules::PopulationCenter
  mount V1::Modules::CreditBilling
  mount V1::Modules::File
  mount V1::Modules::Courier
  mount V1::Modules::Sale
  mount V1::Modules::Inventory


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
