module V1
  module Entities
    class SoldBatch < Grape::Entity
      expose :purchase_id , documentation: { type: "integer", desc: "courier id", example: '1' }
      expose :sale_id , documentation: { type: "integer", desc: "client id", example: '1' }
      expose :grams_picked , documentation: { type: "float", desc: "user id", example: '1' }
    end
  end
end