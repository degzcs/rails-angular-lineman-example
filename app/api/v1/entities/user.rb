module V1
  module Entities
    class User < Grape::Entity
      expose :id, documentation: { type: "string", desc: "id of the user", example: '1' }
      expose :first_name, documentation: { type: "string", desc: " First user name", example: "Lourdez" } do |user, options|
        user.profile.first_name
      end
      expose :last_name, documentation: { type: "string", desc: "Last user name", example: "Astre" } do |user, options|
        user.profile.last_name
      end
      expose :email, documentation: { type: "string", desc: "email", example: "lourdezastre@test.com" }
      expose :document_number, documentation: { type: "string", desc: "email", example: "lourdezastre@test.com" } do |user, options|
        user.profile.document_number
      end
      expose :access_token, documentation: { type: "string", desc: "email", example: "lourdezastre@test.com" } do |user, options|
        user.create_token
      end
      expose :available_credits , documentation: { type: "float", desc: "Available credits", example: 0.0 } do |user,options|
        user.available_credits_based_on_user_role
      end
      expose :phone_number , documentation: { type: "string", desc: "Phone number", example: "312344626" } do |user, options|
        user.profile.phone_number
      end
      expose :address , documentation: { type: "string", desc: "Address", example: "Calle falsa 123" } do |user, options|
        user.profile.address
      end
      expose :company_name, documentation: { type: "string", desc: "", example: "Trazoro." }
      expose :nit, documentation: { type: "string", desc: "", example: "12345617." } do |user, options|
        user.profile.nit_number
      end
      expose :rucom_record, documentation: { type: "string", desc: "", example: "7895465." }
      expose :office, documentation: { type: "string", desc: "", example: "7895465." } do |user, options|
        user.office.name if user.has_office?
      end
      ## TODO: upgrade the frontend in order to avois to send duplicated information like city, state, phone number , etc.
      expose :city, documentation: { type: "json", desc: "", example: "user city" } do |user, options|
        user.profile.city.as_json
      end
      expose :city_name, documentation: { type: "string", desc: "", example: "user city" } do |user, options|
        user.profile.city.name
      end
      expose :phone, documentation: { type: "string", desc: "Phone number", example: "312344626" } do |user, options|
        user.profile.phone_number
      end
      expose :photo_file, documentation: { type: "photo", desc: "photo file", example: "" } do |user, options|
        user.profile.photo_file
      end
      expose :company, documentation: { type: "hash", desc: "company_info", example: "" } do |user, options|
        user.company.as_indexed_json if user.has_office?
      end
      expose :rucom, documentation: { type: "hash", desc: "rucom", example: "" } do |user, options|
        user.rucom.as_json
      end
      expose :user_wacom_device, documentation: { type: 'string', desc: 'enviroment', example: 'true, false' } do |user, _options|
        APP_CONFIG[:USE_WACOM_DEVICE]
      end
    end
  end
end