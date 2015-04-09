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
  after_create :calculate_total

  validates :user_id, presence: true
  validates :unit, presence: true
  validates :per_unit_value, presence: true
  #validates :payment_flag, presence: true


  def iva_value
    self.total_amount * 0.16
  end

  def discount 
    self.total_amount * self.discount_percentage/100
  end

  protected 
    def init
      self.per_unit_value = 1000  
    end
    def calculate_total
      total = self.unit * self.per_unit_value
      CreditBilling.update(self.id,total_amount: total)
    end
end
