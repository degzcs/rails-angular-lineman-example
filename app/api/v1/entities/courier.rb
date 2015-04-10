module V1
  module Entities
    class Courier < Grape::Entity
      expose :id, documentation: { type: "integer", desc: "id of the courier", example: '1' }
      expose :id_document_number, documentation: { type: "string", desc: "Document number of the courier", example: "1968353479" }
      expose :id_document_type, documentation: { type: "string", desc: "Document number of the courier", example: "1968353479" }
      expose :first_name, documentation: { type: "string", desc: "Firstname", example: "Juan" }
      expose :last_name, documentation: { type: "string", desc: "Lastname", example: "Perez" }
      expose :phone_number, documentation: { type: "string", desc: "Phone number", example: "83333333" }
      expose :address, documentation: { type: "string", desc: "Courier address", example: "Calle 1 2 - 3" }
      expose :nit_company_number, documentation: { type: "string", desc: "Courier company's id number", example: "1968353479" }
      expose :company_name, documentation: { type: "string", desc: "Name of the company the courier belongs to", example: "1968353479" }
    end
  end
end