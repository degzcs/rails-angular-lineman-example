# == Schema Information
#
# Table name: gold_batches
#
#  id             :integer          not null, primary key
#  parent_batches :text
#  grams          :float
#  grade          :integer
#  inventory_id   :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class GoldBatch < ActiveRecord::Base
  #
  # Associations
  #
  has_many :purchases
end
