
module V1
  module Entities
    # Entity of grape
    class Sale < Grape::Entity
      expose :id, documentation: { type: 'integer', desc: 'Sale id', example: '1' }
      expose :courier_id, documentation: { type: 'integer', desc: 'courier id', example: '1' }
      expose :buyer, if: lambda { |sale, options| sale.buyer.present? } do
        expose :id, documentation: { type: 'integer', desc: 'buyer id' } do |sale, _options|
          sale.buyer.id
        end
        expose :first_name, documentation: { type: 'string', desc: 'first_name of the buyer, who buys a gold batch in inventory sale' } do |sale, _options|
          sale.buyer.profile.first_name
        end
        expose :last_name, documentation: { type: 'string', desc: 'last_name of the buyer, who buys a gold batch in inventory sale' } do |sale, _options|
          sale.buyer.profile.last_name
        end
        # expose :document_type, documentation: { type: 'integer', desc: 'document_type of the buyer, who buys a gold batch in inventory sale' } do |sale, _options|
        #   sale.buyer.profile.last_name
        # end
        expose :document_number, documentation: { type: 'integer', desc: 'document_number of the buyer, who buys a gold batch in a new sale' } do |sale, _options|
          sale.buyer.profile.document_number
        end
        expose :phone_number, documentation: { type: 'integer', desc: 'phone_number of the buyer, who buys a gold batch in a new sale' } do |sale, _options|
          sale.buyer.profile.phone_number
        end
        expose :address, documentation: { type: 'string', desc: 'adress of the buyer, who buys a gold batch in a new sale' } do |sale, _options|
          sale.buyer.profile.address
        end
        expose :email, documentation: { type: 'string', desc: 'email of the buyer, who buys a gold batch in a new sale' } do |sale, _options|
          sale.buyer.email
        end
      end
      expose :buyer_ids, documentation: { type: 'Array', desc: 'Ids of people who have done a purchase requests' }
      expose :buyers do |sale, _options|
        sale.buyers.map do |buyer|
          buyer_presenter =  UserPresenter.new(buyer, nil)
          {
            id: buyer_presenter.id,
            name: buyer_presenter.name,
            nit_number: buyer_presenter.nit_number,
          }
        end.as_json
      end
      expose :seller do
        expose :id, documentation: { type: 'integer', desc: 'buyer id' } do |sale, _options|
          sale.seller.id
        end
        expose :first_name, documentation: { type: 'string', desc: 'first_name of the seller, who buys a gold batch in inventory sale' } do |sale, _options|
          sale.seller.profile.first_name
        end
        expose :last_name, documentation: { type: 'string', desc: 'last_name of the seller, who buys a gold batch in inventory sale' } do |sale, _options|
          sale.seller.profile.last_name
        end
        # expose :document_type, documentation: { type: 'integer', desc: 'document_type of the seller, who buys a gold batch in inventory sale' } do |sale, _options|
        #   sale.seller.profile.last_name
        # end
        expose :document_number, documentation: { type: 'integer', desc: 'document_number of the seller, who buys a gold batch in a new sale' } do |sale, _options|
          sale.seller.profile.document_number
        end
        expose :phone_number, documentation: { type: 'integer', desc: 'phone_number of the seller, who buys a gold batch in a new sale' } do |sale, _options|
          sale.seller.profile.phone_number
        end
        expose :address, documentation: { type: 'string', desc: 'adress of the seller, who buys a gold batch in a new sale' } do |sale, _options|
          sale.seller.profile.address
        end
        expose :email, documentation: { type: 'string', desc: 'email of the seller, who buys a gold batch in a new sale' } do |sale, _options|
          sale.seller.email
        end
        expose :photo_file_url, documentation: { type: 'string', desc: 'email of the seller, who buys a gold batch in a new sale' } do |sale, _options|
          sale.seller.profile.photo_file.url#(:thumb)
        end
      end
      expose :user_id, documentation: { type: 'integer', desc: 'user id', example: '1' } do |sale, _options|
        sale.seller.id
      end
      expose :gold_batch_id, documentation: { type: 'integer', desc: 'gold batch id', example: '1' } do |sale, _options|
        sale.gold_batch.id
      end

      expose :gold_batch do
        expose :grade, documentation: {} do |sale, _options|
          sale.gold_batch.grade
        end
        expose :fine_grams, documentation: {} do |sale, _options|
          sale.gold_batch.fine_grams
        end
      end
      expose :mineral_type, documentation: { type: 'string', desc: "type mineral of the purchase", example: "Oro"} do |sale, _options|
        sale.gold_batch.mineral_type
      end
      expose :associated_purchases, documentation: { type: 'file', desc: 'sold_batches', example: 'array sold_batches' } do |sale, _options|
        sale.batches.map do |batch|
          purchase = batch.gold_batch.goldomable
          purchase.as_json.merge(
            created_at: purchase.created_at.in_time_zone("Bogota").strftime("%m/%d/%Y - %I:%M%p"),
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
      expose :fine_grams, documentation: { type: 'float', desc: 'grams', example: '239923' }
      expose :code, documentation: { type: 'string', desc: 'barcode', example: '123123asdfdaf' }
      expose :barcode_html, documentation: { type: 'string', desc: 'barcode_html', example: 'TABLE' }
      expose :purchase_files_collection, documentation: { type: 'file', desc: 'purchase_files_collection', example: 'id, miner register, purchase files' } do |sale, _options|
        sale.try(:purchase_files_collection).try(:as_json)
      end
      expose :purchase_files_collection_with_watermark, documentation: { type: 'file', desc: 'purchase_files_collection_with_watermark', example: 'id, miner register, purchase files' } do |sale, _options|
        sale.try(:purchase_files_collection_with_watermark).try(:as_json)
      end
      expose :proof_of_sale, documentation: { type: 'file', desc: 'proof_of_sale', example: 'document_equivalent.pdf' } do |sale, _options|
        sale.proof_of_sale.as_json
      end
      expose :shipment, documentation: { type: 'file', desc: 'file', example: '...' } do |sale, _options|
        sale.shipment.as_json
      end
      expose :price, documentation: { type: 'float', desc: 'price', example: '123399' }
      expose :purchases_total_value, documentation: { type: 'float', desc: 'purchases_total_value', example: '3000.0' }
      expose :total_gain, documentation: { type: 'float', desc: 'total_gain', example: '-40' }
      # expose :access_token, documentation: { type: 'string', desc: 'authentication token', example: 'sjahdkfjhasdfhaskdj' } do |purchase, _options|
      # sale.user.create_token
      # end
      expose :type, documentation: { type: "String", desc: "useful to knwo if gold came from AProvider or Trader", example: "sale, purchase" }
      expose :transaction_state, documentation: { type: 'string', desc: 'sale state', example: 'pending, dispatched, paid, canceled, approved' }
    end
  end
end
