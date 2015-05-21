# == Schema Information
#
# Table name: sold_batches
#
#  id           :integer          not null, primary key
#  purchase_id  :integer
#  grams_picked :float
#  sale_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class SoldBatch < ActiveRecord::Base
  #
  # Associations
  #
  belongs_to :sale
  #
  # Validations
  #

  validates :purchase_id, presence: true
  validates :grams_picked, presence: true

  def purchase 
    Purchase.find(purchase_id)
  end

  def provider 
    Provider.find(purchase.provider_id)
  end

end
