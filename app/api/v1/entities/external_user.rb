module V1
  module Entities
    class ExternalUser < Grape::Entity
      expose :id, documentation: { type: "integer", desc: "id of the user", example: '1' }
      expose :document_number, documentation: { type: "string", desc: "Document number of the provider", example: "1968353479" }  do |user, options|
        user.profile.document_number
      end
      expose :first_name, documentation: { type: "string", desc: "Firstname", example: "Juan" } do |user, options|
        user.profile.first_name
      end
      expose :last_name, documentation: { type: "string", desc: "Lastname", example: "Perez" }  do |user, options|
        user.profile.last_name
      end
      expose :phone_number, documentation: { type: "string", desc: "Phone number", example: "83333333" }  do |user, options|
        user.profile.phone_number
      end
      expose :address, documentation: { type: "string", desc: "Address", example: "Calle falsa n#4233" }  do |user, options|
        user.profile.address
      end
      expose :document_number_file, documentation: { type: "file", desc: "file", example: "..." }  do |user, options|
        user.profile.id_document_file
      end
      expose :mining_register_file, documentation: { type: "file", desc: "file", example: "..." }  do |user, options|
        user.profile.mining_authorization_file
      end
      expose :photo_file, documentation: { type: "file", desc: "file", example: "..." }  do |user, options|
        user.profile.photo_file
      end
      expose :email, documentation: { type: "string", desc: "E-mail address", example: "provider@example.com" }
      expose :city, documentation: { type: "string", desc: "City name", example: "Medellín" }  do |user, options|
        user.profile.city
      end
      expose :state, documentation: { type: "string", desc: "State name", example: "Antioquia" }  do |user, options|
        user.profile.city.state
      end
      expose :company, documentation: { type: "hash", desc: "company_info", example: "" }
      expose :rucom, documentation: { type: "hash", desc: "rucom", example: "" }
    end
  end
end