module V1
  module Entities
    class Client < Grape::Entity
      expose :id, documentation: { type: "integer", desc: "id of the user", example: '1' }
      expose :document_number, documentation: { type: "string", desc: "Document number of the provider", example: "1968353479" }
      expose :first_name, documentation: { type: "string", desc: "Firstname", example: "Juan" }
      expose :last_name, documentation: { type: "string", desc: "Lastname", example: "Perez" }
      expose :phone_number, documentation: { type: "string", desc: "Phone number", example: "83333333" }
      expose :address, documentation: { type: "string", desc: "Address", example: "Calle falsa n#4233" }
      expose :document_number_file, documentation: { type: "file", desc: "file", example: "..." }
      # expose :mining_register_file, documentation: { type: "file", desc: "file", example: "..." }
      # expose :rut_file, documentation: { type: "file", desc: "file", example: "..." }
      # expose :chamber_commerce_file, documentation: { type: "file", desc: "file", example: "..." } do | provider, options|
      #   provider.company.chamber_of_commerce_file if provider.company.present?
      # end
      expose :photo_file, documentation: { type: "file", desc: "file", example: "..." }
      expose :email, documentation: { type: "string", desc: "E-mail address", example: "provider@example.com" }
      expose :city_name, documentation: { type: "string", desc: "City name", example: "Medellín" }
      expose :state_name, documentation: { type: "string", desc: "State name", example: "Antioquia" }
      expose :company, documentation: { type: "hash", desc: "company_info", example: "" }
      expose :rucom, documentation: { type: "hash", desc: "rucom", example: "" }
      expose :population_center, documentation: {type: "hash", desc: "population center", example: ""}
      expose :activity, documentation: {type: "hash", desc: "can be Joyero | Comprador Ocasional | Exportacion", example: "Joyero"}
      expose :city, documentation: { type: "string", desc: "", example: "user city" }
      expose :state, documentation: { type: "string", desc: "State name", example: "Antioquia" }
      expose :external, documentation: { type: "boolean", desc: "External flag", example: "true" }
    end
  end
end