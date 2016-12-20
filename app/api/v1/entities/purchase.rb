module V1
  module Entities
    class Purchase < Grape::Entity
      # format_with(:sold_format) { |purchase| purchase.gold_batch.sold? ? 'Vendido' : 'Disponible' }
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
      expose :proof_of_sale_file_url, documentation: { type: "file", desc: "file", example: '...' } do |purchase, options|
        purchase.proof_of_sale.file.url
      end
      expose :purchase_files_collection, documentation: { type: 'string', desc: 'purchase_files_collection', example: 'id, miner register, purchase files' } do |sale, _options|
        sale.purchase_files_collection.as_json if sale.purchase_files_collection.present?
      end
      expose :origin_certificate_file_url, documentation: { type: "file", desc: "file", example: "..." } do |purchase, options|
        purchase.origin_certificate.try(:file).try(:url)
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
      expose :gold_state, documentation: {type: "boolean", desc: "State to determinate if a gold_batch is sold or not", example: 'true'}
      expose :seller do
        expose :id, documentation: { type: "string", desc: "id of the seller who buys the gold batch", example: "1" }do|purchase, options|
          purchase.seller.id # TODO: change provider for saller in the front end
        end
        expose :first_name, documentation: { type: "string", desc: "first_name of the provider who buys the gold batch", example: "nombre" }do|purchase, options|
          purchase.seller.profile.first_name
        end
        expose :last_name, documentation: { type: "string", desc: "last_name of the provider who buys the gold batch", example: "apellido" }do|purchase, options|
          purchase.seller.profile.last_name
        end
         expose :document_number, documentation: { type: 'integer', desc: 'document_number of the seller, who buys a gold batch in a new purchase' } do |purchase, _options|
          purchase.seller.profile.document_number
        end
        expose :phone_number, documentation: { type: 'integer', desc: 'phone_number of the seller, who buys a gold batch in a new purchase' } do |purchase, _options|
          purchase.seller.profile.phone_number
        end
        expose :address, documentation: { type: 'string', desc: 'adress of the seller, who buys a gold batch in a new purchase' } do |purchase, _options|
          purchase.seller.profile.address
        end
        expose :email, documentation: { type: 'string', desc: 'email of the seller, who buys a gold batch in a new purchase' } do |purchase, _options|
          purchase.seller.email
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
        expose :mineral_type, documentation: { type: 'string', desc: "type mineral of the purchase", example: "Oro"} do|purchase, options|
          purchase.gold_batch.mineral_type
        end
        expose :fine_grams, documentation: { type: 'float', desc: 'grams', example: '239923' } do |purchase, options|
          purchase.gold_batch.fine_grams
        end
      end
      # TODO: remove this inventory namespace as soon as the frontend being upgrated
      expose :inventory do
        expose :remaining_amount, documentation: { type: "string", desc: "inventory remaining_amount", example: "123456789" } do|purchase, options|
          Order.remaining_amount_for(purchase.buyer).round(2)
        end
      end
      expose :type, documentation: { type: "String", desc: "useful to knwo if gold came from AProvider or Trader", example: "sale, purchase" }
      expose :trazoro, documentation: { type: " boolean", desc: "trazoro", example: "true" }
      # expose :sale_id, documentation: { type: " integer", desc: "sale_id", example: 1 }
      expose :performer do
        expose :first_name, documentation: { type: "string", desc: "first_name of the buyer who buys the gold batch", example: "nombre" }do|purchase, options|
          purchase.audits.first.user.profile.first_name
        end
        expose :last_name, documentation: { type: "string", desc: "last_name of the buyer who buys the gold batch", example: "apellido" }do|purchase, options|
          purchase.audits.first.user.profile.last_name
        end
      end
      expose :transaction_state, documentation: { type: 'string', desc: 'sale state', example: 'pending, dispatched, paid, canceled, approved' }
      expose :associated_purchases, documentation: { type: 'file', desc: 'sold_batches', example: 'array sold_batches' } do |sale, _options|
        sale.batches.map do |batch|
          purchase = batch.gold_batch.goldomable
          purchase.as_json.merge(
            created_at: purchase.created_at.in_time_zone("Bogota").strftime("%m/%d/%Y - %I:%M%p"),
            fine_grams: purchase.fine_grams.round(2), # This method is delagated to gold_batch model
            seller: {
              first_name: purchase.seller.profile.first_name,
              last_name: purchase.seller.profile.last_name,
              provider_type: purchase.seller.provider_type,
            }
          )
        end.as_json
      end
    end
  end
end
