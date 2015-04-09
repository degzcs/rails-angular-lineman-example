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
  before_save :calculate_total

  validates :user_id, presence: true
  validates :unit, presence: true
  validates :per_unit_value, presence: true
  validates :discount_percentage, presence: { message: "El porcentaje de descuento debe ser un valor entre 0 y 100" },  :inclusion => 0..100
  #validates :payment_flag, presence: true


  def iva_value
    self.total_amount * 0.16
  end

  protected 
    def init
      self.per_unit_value = 1000  
    end
    def calculate_total
      subtotal = self.unit * self.per_unit_value
      discount = subtotal * self.discount_percentage/100
      self.discount = discount
      self.total_amount = subtotal - discount
    end
end
