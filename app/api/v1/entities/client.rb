module V1
  module Entities
    class Client < Grape::Entity
      expose :id, documentation: { type: "integer", desc: "id of the user", example: '1' }
      expose :id_document_number, documentation: { type: "string", desc: "Document number of the client", example: "1968353479" }
      expose :id_document_type, documentation: { type: "string", desc: "Document number of the client", example: "1968353479" }
      expose :first_name, documentation: { type: "string", desc: "Firstname", example: "Juan" }
      expose :last_name, documentation: { type: "string", desc: "Lastname", example: "Perez" }
      expose :phone_number, documentation: { type: "string", desc: "Phone number", example: "83333333" }
      expose :address, documentation: { type: "string", desc: "Address", example: "Calle falsa n#4233" }
      expose :email, documentation: { type: "string", desc: "E-mail address", example: "client@example.com" }
      expose :client_type, documentation: { type: "string", desc: "Client type", example: "client@example.com" }
      expose :company_name, documentation: { type: "string", desc: "Name of the company the client belongs to", example: "client@example.com" }
      expose :nit_company_number, documentation: { type: "string", desc: "Name of the company the client belongs to", example: "client@example.com" }
      expose :rucom do 
        expose :id, documentation: { type: "integer", desc: "Id of the Rucom", example: "4" } do |client, options|
          client.rucom.id if client.rucom
        end
        expose :status, documentation: { type: "string", desc: "status of the Rucom", example: "Active" } do |client, options|
          client.rucom.status if client.rucom
        end
        expose :num_rucom, documentation: { type: "string", desc: "num_rucom", example: "Rucom213" } do |client, options|
          client.rucom.num_rucom if client.rucom
        end
        expose :rucom_record, documentation: { type: "string", desc: "rucom_record", example: "Rucom record" } do |client, options|
          client.rucom.rucom_record if client.rucom
        end
        expose :provider_type, documentation: { type: "string", desc: "provider_type", example: "1233" } do |client, options|
          client.rucom.provider_type if client.rucom
        end
        expose :mineral, documentation: { type: "string", desc: "mineral", example: "Oro" } do |client, options|
          client.rucom.mineral if client.rucom
        end
      end
      expose :population_center do 
        expose :id, documentation: { type: "integer", desc: "Id of the population center", example: "4" } do |client, options|
          client.population_center.id if client.population_center
        end
        expose :name, documentation: { type: "string", desc: "name of the population center", example: "Medellin" } do |client, options|
          client.population_center.name if client.population_center
        end
        expose :population_center_code, documentation: { type: "text", desc: "Population center code", example: "05001000" } do |client, options|
          client.population_center.population_center_code if client.population_center
        end
      end
    end
  end
end