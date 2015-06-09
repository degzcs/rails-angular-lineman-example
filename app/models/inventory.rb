# == Schema Information
#
# Table name: inventories
#
#  id               :integer          not null, primary key
#  purchase_id      :integer
#  remaining_amount :float            not null
#  status           :boolean          default(TRUE), not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Inventory < ActiveRecord::Base
  belongs_to :purchase
  validates :purchase_id , presence: true
  validates :remaining_amount , presence: true

  class EmptyInventory < StandardError
  end

  #updates inventory remaingin amount
  def discount_remainig_amount(amount_picked)
    new_amount = (remaining_amount - amount_picked).round(2)
    raise EmptyInventory if new_amount <= 0
    update_attribute(:remaining_amount,new_amount)
  end
end
