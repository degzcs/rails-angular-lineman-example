
module V1
  module Entities
    # Entity of grape
    class Sale < Grape::Entity
      expose :id, documentation: { type: 'integer', desc: 'Sale id', example: '1' }
      expose :courier_id, documentation: { type: 'integer', desc: 'courier id', example: '1' }
      expose :buyer do
        expose :id, documentation: { type: 'integer', desc: 'buyer id' } do |sale, _options|
          sale.buyer.id
        end
        expose :first_name, documentation: { type: 'integer', desc: 'first_name of the buyer, who buys a gold batch in inventory sale' } do |sale, _options|
          sale.buyer.profile.first_name
        end
        expose :last_name, documentation: { type: 'integer', desc: 'last_name of the buyer, who buys a gold batch in inventory sale' } do |sale, _options|
          sale.buyer.profile.last_name
        end
      end
      expose :user_id, documentation: { type: 'integer', desc: 'user id', example: '1' } do |sale, _options|
        sale.inventory.user.id
      end
      expose :gold_batch_id, documentation: { type: 'integer', desc: 'gold batch id', example: '1' } do |sale, _options|
        sale.gold_batch.id
      end
       expose :associated_purchases, documentation: { type: 'file', desc: 'sold_batches', example: 'array sold_batches' } do |sale, _options|
        sale.batches.map do |batch|
          purchase = batch.gold_batch.goldomable
          purchase.as_json.merge(
              fine_grams: purchase.fine_grams, # This method is delagated to gold_batch model
              seller: {
                first_name: purchase.seller.profile.first_name,
                last_name: purchase.seller.profile.last_name,
                provider_type: purchase.seller.provider_type,
              }
            )
        end.as_json
      end
      expose :created_at, documentation: { type: 'created at', desc: 'date', example: 'date' } do |purchase, _options|
        purchase.created_at.in_time_zone('Bogota').strftime("%m/%d/%Y - %I:%M%p")
      end
      expose :fine_grams, documentation: { type: 'float', desc: 'grams', example: '239923' }
      expose :code, documentation: { type: 'string', desc: 'barcode', example: '123123asdfdaf' }
      expose :barcode_html, documentation: { type: 'string', desc: 'barcode_html', example: 'TABLE' }
      expose :purchase_files_collection, documentation: { type: 'string', desc: 'purchase_files_collection', example: 'id, miner register, purchase files' } do |sale, _options|
        sale.purchase_files_collection.as_json
      end
      expose :proof_of_sale, documentation: { type: 'file', desc: 'proof_of_sale', example: 'document_equivalent.pdf' } do |sale, _options|
        sale.proof_of_sale.as_json
      end
      expose :price, documentation: { type: 'float', desc: 'price', example: '123399' }
      expose :purchases_total_value, documentation: { type: 'float', desc: 'purchases_total_value', example: '3000.0' }
      expose :total_gain, documentation: { type: 'float', desc: 'total_gain', example: '-40' }
      # expose :access_token, documentation: { type: 'string', desc: 'authentication token', example: 'sjahdkfjhasdfhaskdj' } do |purchase, _options|
      # sale.user.create_token
      # end
    end
  end
end
