 module V1
  module Entities
    class CreditBilling < Grape::Entity
      expose :quantity, documentation: { type: "Float", desc: "Unit", example: '...' }
      expose :unit_price, documentation: { type: "Float", desc: "Per unit value", example: '...' }
      expose :vat, documentation: { type: "Float", desc: "Iva Value", example: '...' }
      expose :discount, documentation: { type: "Float", desc: "Discount", example: '...' }
      expose :total_amount, documentation: { type: "Float", desc: "Total amount", example: '...' }
      expose :paid, documentation: { type: "Boolean", desc: "Payment flag", example: '...' }
      expose :payment_date, documentation: { type: "Datetime", desc: "Payment date", example: '...' }
      expose :discount_percentage, documentation: { type: "Float", desc: "Discount percentage", example: '...' }
    end
  end
end