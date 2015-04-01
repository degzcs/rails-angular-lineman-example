module V1
  module Entities
    class Provider < Grape::Entity
      expose :id, documentation: { type: "integer", desc: "id of the user", example: '1' }
      expose :document_number, documentation: { type: "string", desc: "Document number of the provider", example: "1968353479" }
      expose :first_name, documentation: { type: "string", desc: "Firstname", example: "Juan" }
      expose :last_name, documentation: { type: "string", desc: "Lastname", example: "Perez" }
      expose :phone_number, documentation: { type: "string", desc: "Phone number", example: "83333333" }
      expose :address, documentation: { type: "string", desc: "Address", example: "Calle falsa n#4233" }
      expose :rucom do 
        expose :id, documentation: { type: "integer", desc: "Id of the Rucom", example: "4" } do |provider, options|
          provider.rucom.id
        end
        expose :status, documentation: { type: "string", desc: "status of the Rucom", example: "Active" } do |provider, options|
          provider.rucom.status
        end
        expose :num_rucom, documentation: { type: "string", desc: "num_rucom", example: "Rucom213" } do |provider, options|
          provider.rucom.num_rucom
        end
      end
      expose :company_info , :unless => Proc.new {|p| p.company_info.nil?} do
        expose :id, documentation: { type: "integer", desc: "Id of the Company info", example: "4" } do |provider, options|
          provider.company_info.id
        end
        expose :nit_number, documentation: { type: "integer", desc: "nit number of the company ", example: "44356634634-2" } do |provider, options|
          provider.company_info.nit_number
        end
        expose :name, documentation: { type: "integer", desc: "name of the company ", example: "Texaco" } do |provider, options|
          provider.company_info.name
        end
      end
    end
  end
end