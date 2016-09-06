module V1
  module Entities
    class Purchase < Grape::Entity
      #format_with(:sold_format) { |purchase| purchase.gold_batch.sold? ? 'Vendido' : 'Disponible' }

      expose :id, documentation: { type: "string", desc: "id of the purchase", example: '1' }
      expose :user_id, documentation: { type: "string", desc: "id of the purchaser who buys the gold batch", example: "1" } do |purchase, options|
        purchase.buyer.id # TODO: remove this temporal fix
      end
      expose :price, documentation: { type: "float", desc: "price payed for the gold", example: "20000.25" } do |purchase, options|
        purchase.price.round(2)
      end
      expose :proof_of_purchase_file_url, documentation: { type: "file", desc: "file", example: '...' } do |purchase, options|
        purchase.proof_of_purchase.file.url
      end
      expose :origin_certificate_file_url, documentation: { type: "file", desc: "file", example: "..." } do |purchase, options|
        purchase.origin_certificate.file.url
      end
      expose :seller_picture, documentation: { type: "file", desc: "file", example: "..." }
      expose :created_at, documentation: { type: "created at", desc: "date", example: "date" } do |purchase, options|
        purchase.created_at.in_time_zone("Bogota").strftime("%m/%d/%Y - %I:%M%p")
      end
      expose :barcode_html, documentation: {type: "string", desc: "barcode in html format", example: ''}
      expose :code, documentation: {type: "string", desc: "code with 12 characteres in charged to generate the barcode", example: '075124874512'}
      expose :access_token, documentation: { type: "string", desc: "authentication token", example: "sjahdkfjhasdfhaskdj" } do |purchase, options|
        purchase.buyer.create_token
      end
      expose :state, documentation: {type: "boolean", desc: "State to determinate if a gold_batch is sold or not", example: 'true'}
      expose :seller do
        expose :id, documentation: { type: "string", desc: "id of the seller who buys the gold batch", example: "1" }do|purchase, options|
          purchase.seller.id # TODO: change provider for saller in the front end
        end
        expose :first_name, documentation: { type: "string", desc: "first_name of the provider who buys the gold batch", example: "1" }do|purchase, options|
          purchase.seller.profile.first_name
        end
        expose :last_name, documentation: { type: "string", desc: "last_name of the provider who buys the gold batch", example: "1" }do|purchase, options|
          purchase.seller.profile.last_name
        end
      end
      expose :gold_batch do
        expose :id, documentation: { type: "string", desc: "gold batch id", example: "1" } do|purchase, options|
          purchase.gold_batch.id
        end
        expose :grams, documentation: { type: "float", desc: "gold batch total grams", example: "2.5" } do|purchase, options|
          purchase.gold_batch.fine_grams.round(2)
        end
        expose :grade, documentation: { type: "float", desc: "gold batch total grams", example: "2.5" } do|purchase, options|
          purchase.gold_batch.grade
        end
        expose :sold, documentation: { type: 'boolean', desc: "State to determinate if a gold_batch is sold or not", example: "true"} do|purchase, options|
          purchase.gold_batch.sold
        end
      end
      # TODO: remove this inventory namespace as soon as the frontend being upgrated
      expose :inventory do
        expose :remaining_amount, documentation: { type: "string", desc: "inventory remaining_amount", example: "123456789" } do|purchase, options|
          Order.remaining_amount_for(purchase.buyer).round(2)
        end
      end
      expose :trazoro, documentation: { type: " boolean", desc: "trazoro", example: "true" }
        # expose :sale_id, documentation: { type: " integer", desc: "sale_id", example: 1 }
    end
  end
end
