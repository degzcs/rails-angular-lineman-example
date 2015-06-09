module V1
  module Entities
    class SaleForPurchase < Grape::Entity
      expose :id ,documentation: { type: "integer", desc: "Sale id", example: '1' }
      expose :gold_batch_id ,documentation: { type: "integer", desc: "gold batch id", example: '1' }
      expose :fine_grams ,documentation: { type: "float", desc: "grams", example: '239923' }
      expose :grade ,documentation: { type: "float", desc: "grade", example: '999' }
      expose :fine_gram_unit_price ,documentation: { type: "float", desc: "price per fine gram", example: '4654789' }
      expose :code ,documentation: { type: "string", desc: "number user to create a barcode", example: '123123asdfdaf' }
      expose :origin_certificate_file, documentation: { type: "file", desc: "pdf with all previous origin certificates to the current one" }
      expose :provider, documentation: { type: "string", desc: "information about the persorn who made the sale" } do | sale, options|
        #IMPROVE: this entity was created provitionaly in order to convert the user in provider. Have to be refactored!!
        #sale.user.attributes.symbolize_keys.except(:created_at, :updated_at, :password_digest, :reset_token, :document_expedition_date)
        user_transformed_to_provider = {
          id: sale.user.id,
          name: "#{sale.user.first_name} #{sale.user.last_name}",
          company_name: sale.user.company.name,
          document_type: 'NIT',
          document_number: sale.user.company.nit_number,
          rucom_record:  sale.user.rucom.rucom_record,
          num_rucom:  sale.user.rucom.num_rucom,
          rucom_status: sale.user.rucom.status
        }
      end
    end
  end
end