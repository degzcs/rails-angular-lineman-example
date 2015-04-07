class GoldBatch < ActiveRecord::Base
  #
  # Associations
  #
  has_many :purchases
end
