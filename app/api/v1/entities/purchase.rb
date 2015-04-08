module V1
  module Entities
    class Purchase < Grape::Entity
      expose :id, documentation: { type: "string", desc: "id of the purchase", example: '1' }
      expose :user_id, documentation: { type: "string", desc: "id of the purchaser who buys the gold batch", example: "1" }
      expose :provider_id, documentation: { type: "string", desc: "id of the seller who buys the gold batch", example: "1" }
      expose :gold_batch_id, documentation: { type: "string", desc: "gold batch id", example: "1" }
      expose :price, documentation: { type: "float", desc: "price payed for the gold", example: "20000.25" }
      expose :origin_certificate_file, documentation: { type: "file", desc: "file", example: "..." }
      expose :origin_certificate_sequence, documentation: { type: "string", desc: "sequence", example: "123456789" }
      expose :access_token, documentation: { type: "string", desc: "authentication token", example: "sjahdkfjhasdfhaskdj" } do |purchase, options|
        purchase.user.create_token
      end
    end
  end
end