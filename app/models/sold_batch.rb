# == Schema Information
#
# Table name: sold_batches
#
#  id            :integer          not null, primary key
#  grams_picked  :float
#  created_at    :datetime
#  updated_at    :datetime
#  gold_batch_id :integer
#  order_id      :integer
#

# TODO: the grams_picked field should be remove, because though
# the gold can be split physically the origin certificate cannot be split
# So this field is unnecesary and it is deprecated from now on.
class SoldBatch < ActiveRecord::Base
  #
  # Associations
  #

  belongs_to :order
  belongs_to :gold_batch

  #
  # Validations
  #

  validates :gold_batch, presence: true
  # validates :grams_picked, presence: true

  def provider
    purchase.inventory.user
  end

  def purchase
    gold_batch.goldomable
  end

end
