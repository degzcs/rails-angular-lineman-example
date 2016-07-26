
module V1
  module Entities
    class Sale < Grape::Entity
      expose :id ,documentation: { type: "integer", desc: "Sale id", example: '1' }
      expose :courier_id ,documentation: { type: "integer", desc: "courier id", example: '1' }
      expose :buyer_id ,documentation: { type: "integer", desc: "buyer id", example: '1' }
      expose :user_id ,documentation: { type: "integer", desc: "user id", example: '1' } do |sale, options|
        sale.inventory.user.id
      end
      expose :gold_batch_id ,documentation: { type: "integer", desc: "gold batch id", example: '1' } do |sale, options|
        sale.gold_batch.id
      end
      expose :fine_grams ,documentation: { type: "float", desc: "grams", example: '239923' }
      expose :code ,documentation: { type: "string", desc: "barcode", example: '123123asdfdaf' }
      expose :barcode_html ,documentation: { type: "string", desc: "barcode_html", example: 'TABLE' }
      expose :purchase_files_collection, documentation: { type: "string", desc: "purchase_files_collection", example: 'id, miner register, purchase files' } do |sale, options|
        sale.purchase_files_collection.as_json
      end
      expose :proof_of_sale, documentation: { type: 'file', desc: 'proof_of_sale', example: 'document_equivalent.pdf'} do |sale, options|
        sale.proof_of_sale.as_json
      end
      expose :price, documentation: { type: "float", desc: "price", example: '123399' }
    end
  end
end