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
  belongs_to :purchase
  #
  # Validations
  #

  validates :purchase_id, presence: true
  validates :grams_picked, presence: true

  def provider
    purchase.provider
  end

end
