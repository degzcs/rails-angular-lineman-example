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
    user { create(:user, :with_company) }
    remaining_amount { 0 }
    status false
  end
end
