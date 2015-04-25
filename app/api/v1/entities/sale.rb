
module V1
  module Entities
    class Sale < Grape::Entity
      expose :id ,documentation: { type: "integer", desc: "Sale id", example: '1' }
      expose :courier_id ,documentation: { type: "integer", desc: "courier id", example: '1' }
      expose :client_id ,documentation: { type: "integer", desc: "client id", example: '1' }
      expose :user_id ,documentation: { type: "integer", desc: "user id", example: '1' }
      expose :gold_batch_id ,documentation: { type: "integer", desc: "gold batch id", example: '1' }
      expose :grams ,documentation: { type: "float", desc: "grams", example: '239923' }
      expose :barcode ,documentation: { type: "string", desc: "barcode", example: '123123asdfdaf' }
    end
  end
end