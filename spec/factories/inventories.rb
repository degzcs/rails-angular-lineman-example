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

FactoryGirl.define do
  factory :inventory do
    purchase
    remaining_amount { rand(1..2) }
    status false
  end
end
