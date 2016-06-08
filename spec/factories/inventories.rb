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

FactoryGirl.define do
  factory :inventory do
    purchase
    remaining_amount { rand(1..2) }
    status false
  end
end
