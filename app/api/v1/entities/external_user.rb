module V1
  module Entities
    class ExternalUser < Grape::Entity
      expose :id, documentation: { type: "integer", desc: "id of the user", example: '1' }
      expose :document_number, documentation: { type: "string", desc: "Document number of the provider", example: "1968353479" }
      expose :first_name, documentation: { type: "string", desc: "Firstname", example: "Juan" }
      expose :last_name, documentation: { type: "string", desc: "Lastname", example: "Perez" }
      expose :phone_number, documentation: { type: "string", desc: "Phone number", example: "83333333" }
      expose :address, documentation: { type: "string", desc: "Address", example: "Calle falsa n#4233" }
      expose :document_number_file, documentation: { type: "file", desc: "file", example: "..." }
      expose :mining_register_file, documentation: { type: "file", desc: "file", example: "..." }
      expose :photo_file, documentation: { type: "file", desc: "file", example: "..." }
      expose :email, documentation: { type: "string", desc: "E-mail address", example: "provider@example.com" }
      expose :city, documentation: { type: "string", desc: "City name", example: "Medellín" }
      expose :state, documentation: { type: "string", desc: "State name", example: "Antioquia" }
      expose :company, documentation: { type: "hash", desc: "company_info", example: "" }
      expose :rucom, documentation: { type: "hash", desc: "rucom", example: "" }
      expose :population_center, documentation: {type: "hash", desc: "population center", example: ""}
    end
  end
end