module V1
  module Entities
    class SaleForPurchase < Grape::Entity
      expose :id ,documentation: { type: "integer", desc: "Sale id", example: '1' }
      expose :gold_batch_id ,documentation: { type: "integer", desc: "gold batch id", example: '1' }
      expose :grams ,documentation: { type: "float", desc: "grams", example: '239923' }
      expose :code ,documentation: { type: "string", desc: "number user to create a barcode", example: '123123asdfdaf' }
      expose :provider, documentation: { type: "string", desc: "information about the persorn who made the sale" } do | sale, options|
        #IMPROVE: this entity was created provitionaly in order to convert the user in provider. Have to be refactored!!
        #sale.user.attributes.symbolize_keys.except(:created_at, :updated_at, :password_digest, :reset_token, :document_expedition_date)
          user_transformed_to_provider = {
            name: "#{sale.user.first_name} #{sale.user.last_name}",
            company_name: "TrazOro",
            document_type: 'cedula',
            document_number: sale.user.document_number,
            rucom_record:  "0025478",
            rucom_status: 'active'
          }
      end
      #TODO:  collection of all previous origin certificates
      # expose :origin_certificate_file: {}
    end
  end
end