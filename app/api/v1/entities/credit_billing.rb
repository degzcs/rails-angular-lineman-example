# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  unit                :string(255)
#  per_unit_value      :float
#  iva_value           :float
#  discount            :float
#  total_amount        :float
#  payment_flag        :boolean
#  payment_date        :datetime
#  discount_percentage :float
#  created_at          :datetime
#  updated_at          :datetime
#
module V1
  module Entities
    class CreditBilling < Grape::Entity
      expose :unit, documentation: { type: "String", desc: "Unit", example: '...' }
      expose :per_unit_value, documentation: { type: "Float", desc: "Per unit value", example: '...' }
      expose :iva_value, documentation: { type: "Float", desc: "Iva Value", example: '...' }
      expose :discount, documentation: { type: "Float", desc: "Discount", example: '...' }
      expose :total_amount, documentation: { type: "Float", desc: "Total amount", example: '...' }
      expose :payment_flag, documentation: { type: "Boolean", desc: "Payment flag", example: '...' }
      expose :payment_date, documentation: { type: "Datetime", desc: "Payment date", example: '...' }
      expose :discount_percentage, documentation: { type: "Float", desc: "Discount percentage", example: '...' }
    end
  end
end