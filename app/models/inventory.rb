# == Schema Information
#
# Table name: inventories
#
#  id               :integer          not null, primary key
#  remaining_amount :float            not null
#  status           :boolean          default(TRUE), not null
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#

class Inventory
  #
  # Associations
  #

  # belongs_to :user
  # has_many :purchases, dependent: :destroy
  # has_many :sales, dependent: :destroy

  # #
  # # Validations
  # #

  # validates :remaining_amount , presence: true
  # validates :user , presence: true

  class EmptyInventory < StandardError
  end

  #
  # Instance Methods
  #

  def available_gold_batches
    GoldBatch.available.by_type(Purchase).by_goldomable_id(purchase_ids)
  end

  def sold_gold_batches
    GoldBatch.sold.by_type(Purchase).by_goldomable_id(purchase_ids)
  end

  # Updates inventory remaining amount
  def discount_remainig_amount(amount_picked)
    new_amount = (remaining_amount - amount_picked).round(2)
    raise EmptyInventory if new_amount <= 0
    update_attribute(:remaining_amount, new_amount)
  end
end
