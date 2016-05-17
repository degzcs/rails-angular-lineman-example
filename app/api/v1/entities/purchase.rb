module V1
  module Entities
    class Purchase < Grape::Entity
      expose :id, documentation: { type: "string", desc: "id of the purchase", example: '1' }
      expose :user_id, documentation: { type: "string", desc: "id of the purchaser who buys the gold batch", example: "1" }
      expose :price, documentation: { type: "float", desc: "price payed for the gold", example: "20000.25" } do|purchase, options|
        purchase.price.round(2)
      end
      expose :proof_of_purchase_file_url, documentation: { type: 'file', desc: 'file', example: '...' } do |purchase, options|
        purchase.proof_of_purchase.file.url
      end
      expose :origin_certificate_file, documentation: { type: "file", desc: "file", example: "..." }
      expose :seller_picture, documentation: { type: "file", desc: "file", example: "..." }
      expose :origin_certificate_sequence, documentation: { type: "string", desc: "sequence", example: "123456789" }
      expose :created_at, documentation: { type: "created at", desc: "date", example: "date" } do |purchase, options|
        purchase.created_at.in_time_zone("Bogota").strftime("%m/%d/%Y - %I:%M%p")
      end
      expose :barcode_html, documentation:{type: "string", desc: "barcode in html format", example: ''}
      expose :code, documentation:{type: "string", desc: "code with 12 characteres in charged to generate the barcode", example: '075124874512'}
      expose :access_token, documentation: { type: "string", desc: "authentication token", example: "sjahdkfjhasdfhaskdj" } do |purchase, options|
        purchase.user.create_token
      end
      expose :provider do
        expose :id , documentation: { type: "string", desc: "id of the seller who buys the gold batch", example: "1" }do|purchase, options|
          purchase.provider.id
        end
        expose :first_name, documentation: { type: "string", desc: "first_name of the provider who buys the gold batch", example: "1" }do|purchase, options|
          purchase.provider.first_name
        end
        expose :last_name, documentation: { type: "string", desc: "last_name of the provider who buys the gold batch", example: "1" }do|purchase, options|
          purchase.provider.last_name
        end
      end
      expose :gold_batch do
        expose :id , documentation: { type: "string", desc: "gold batch id", example: "1" } do|purchase, options|
          purchase.gold_batch.id
        end
        expose :grams , documentation: { type: "float", desc: "gold batch total grams", example: "2.5" } do|purchase, options|
          purchase.gold_batch.fine_grams.round(2)
        end
        expose :grade , documentation: { type: "float", desc: "gold batch total grams", example: "2.5" } do|purchase, options|
          purchase.gold_batch.grade
        end
      end
      expose :inventory do
        expose :id , documentation: { type: "integer", desc: "inventory id", example: "123456789" }do|purchase, options|
          purchase.inventory.id
        end
        expose :status  , documentation: { type: "string", desc: "inventory status", example: "123456789" }do|purchase, options|
          purchase.inventory.status
        end
        expose :remaining_amount, documentation: { type: "string", desc: "inventory remaining_amount", example: "123456789" } do|purchase, options|
          purchase.inventory.remaining_amount.round(2)
        end
      end
      expose :trazoro, documentation: { type: " boolean", desc: "trazoro", example: "true" }
      expose :sale_id, documentation: { type: " integer", desc: "sale_id", example: 1 }
    end
  end
end