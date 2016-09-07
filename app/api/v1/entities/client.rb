module V1
  module Entities
    class Client < Grape::Entity
      expose :id, documentation: { type: "integer", desc: "id of the user", example: '1' }
      expose :document_number, documentation: { type: "string", desc: "Document number of the provider", example: "1968353479" } do |user, options|
        user.profile.document_number
      end
      expose :first_name, documentation: { type: "string", desc: "Firstname", example: "Juan" } do |user, options|
        user.profile.first_name
      end
      expose :last_name, documentation: { type: "string", desc: "Lastname", example: "Perez" } do |user, options|
        user.profile.last_name
      end
      expose :phone_number, documentation: { type: "string", desc: "Phone number", example: "83333333" } do |user, options|
        user.profile.phone_number
      end
      expose :address, documentation: { type: "string", desc: "Address", example: "Calle falsa n#4233" } do |user, options|
        user.profile.address
      end
      expose :document_number_file, documentation: { type: "file", desc: "file", example: "..." } do |user, options|
        user.profile.id_document_file
      end
      # expose :mining_register_file, documentation: { type: "file", desc: "file", example: "..." }
      # expose :rut_file, documentation: { type: "file", desc: "file", example: "..." }
      # expose :chamber_commerce_file, documentation: { type: "file", desc: "file", example: "..." } do | provider, options|
      #   provider.company.chamber_of_commerce_file if provider.company.present?
      # end
      expose :photo_file, documentation: { type: "file", desc: "file", example: "..." } do |user, options|
        user.profile.photo_file
      end
      expose :email, documentation: { type: "string", desc: "E-mail address", example: "provider@example.com" }
      # TODO: upgrade the client views to avoid to send duplicate state and city data.
      expose :city_name, documentation: { type: "string", desc: "City name", example: "Medellín" } do |user, options|
        user.profile.city_name
      end
      expose :state_name, documentation: { type: "string", desc: "State name", example: "Antioquia" } do |user, options|
        user.profile.city.state.name
      end
      expose :company, documentation: { type: "json", desc: "company_info", example: "" } do |user, options|
        user.company.as_indexed_json if user.has_office?
      end
      expose :rucom, documentation: { type: "json", desc: "rucom", example: "" } do |user, options|
        user.rucom.as_json
      end
      expose :activity, documentation: {type: "hash", desc: "can be Joyero | Comprador Ocasional | Exportacion", example: "Joyero"}
      expose :city, documentation: { type: "json", desc: "", example: "user city" } do |user, options|
        user.profile.city.as_json
      end
      expose :state, documentation: { type: "json", desc: "State name", example: "Antioquia" } do |user, options|
        user.profile.city.state.as_json
      end
    end
  end
end