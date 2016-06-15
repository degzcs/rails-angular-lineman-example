
module V1
  module Entities
    class Sale < Grape::Entity
      expose :id ,documentation: { type: "integer", desc: "Sale id", example: '1' }
      expose :courier_id ,documentation: { type: "integer", desc: "courier id", example: '1' }
      expose :client_id ,documentation: { type: "integer", desc: "client id", example: '1' } do |sale, options|
        sale.buyer_id # TODO: upgrade frontend with this new name
      end
      expose :user_id ,documentation: { type: "integer", desc: "user id", example: '1' } do |sale, options|
        sale.inventory.user.id
      end
      expose :gold_batch_id ,documentation: { type: "integer", desc: "gold batch id", example: '1' } do |sale, options|
        sale.gold_batch.id
      end
      expose :fine_grams ,documentation: { type: "float", desc: "grams", example: '239923' }
      expose :code ,documentation: { type: "string", desc: "barcode", example: '123123asdfdaf' }
      expose :barcode_html ,documentation: { type: "string", desc: "barcode_html", example: 'TABLE' }
      expose :origin_certificate_file, documentation: { type: "string", desc: "origin_certificate_file", example: 'TABLE' } do |sale, options|
       # NOTE: this field must to be changed in the front-end
       sale.purchase_files_collection.file
      end
      expose :price, documentation: { type: "float", desc: "price", example: '123399' }
    end
  end
end