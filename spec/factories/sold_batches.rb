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

FactoryGirl.define do
  factory :sold_batch do
    purchase
    grams_picked 2.5
    sale
  end
end
