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

class CreditBilling < ActiveRecord::Base
  belongs_to :user
  after_initialize :init

  validates :user_id, presence: true
  validates :unit, presence: true
  validates :per_unit_value, presence: true
  validates :iva_value, presence: true
  validates :total_amount, presence: true
  #validates :payment_flag, presence: true

  protected 
    def init
      self.unit ||= 1  
      self.per_unit_value ||= 1000  
      self.iva_value ||= 16  
      self.payment_flag = false
    end
end
