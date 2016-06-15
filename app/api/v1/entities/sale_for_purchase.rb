module V1
  module Entities
    class SaleForPurchase < Grape::Entity
      expose :id ,documentation: { type: "integer", desc: "Sale id", example: '1' }
      expose :gold_batch_id ,documentation: { type: "integer", desc: "gold batch id", example: '1' } do |sale, options|
        sale.gold_batch.id
      end
      expose :fine_grams ,documentation: { type: "float", desc: "grams", example: '239923' }
      expose :grade ,documentation: { type: "float", desc: "grade", example: '999' }
      expose :fine_gram_unit_price ,documentation: { type: "float", desc: "price per fine gram", example: '4654789' }
      expose :code ,documentation: { type: "string", desc: "number user to create a barcode", example: '123123asdfdaf' }
      expose :origin_certificate_file,
        documentation: { type: "file", desc: "pdf with all previous origin certificates to the current one" } do |sale, options|
        sale.purchase_files_collection.file
      end
      expose :provider, documentation: { type: "string", desc: "information about the persorn who made the sale" } do | sale, options|
        #IMPROVE: this entity was created provitionaly in order to convert the user in provider. Have to be refactored!!
        seller = legal_representative = V1::Helpers::UserHelper.legal_representative_from(sale.inventory.user)
        user_transformed_to_provider = {
          id: seller.id,
          name: "#{ seller.first_name } #{ seller.last_name }",
          company_name: seller.company.name,
          document_type: 'NIT',
          document_number: seller.company.nit_number,
          rucom_record:  seller.company.rucom.rucom_record,
          num_rucom:  seller.company.rucom.num_rucom,
          rucom_status: seller.company.rucom.status
        }
      end
    end
  end
end