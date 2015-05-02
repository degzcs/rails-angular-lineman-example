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

FactoryGirl.define do
  factory :gold_batch do
    parent_batches ""
    grams 100
    grade 1
    inventory_id 1
  end

end
