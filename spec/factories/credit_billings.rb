# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  payment_date        :datetime
#  discount_percentage :float            default(0.0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  total_amount        :float            default(0.0), not null
#  discount            :float            default(0.0), not null
#  paid                :boolean          default(FALSE)
#  quantity            :float
#  unit_price          :float
#  invoiced            :boolean          default(FALSE)
#  alegra_id           :integer
#

FactoryGirl.define do
  factory :credit_billing do
    quantity { 10 }
    unit_price { 1000 }
    paid true
    payment_date { Time.now }
    discount_percentage { 0 }
    user { create :user, :with_profile, :with_personal_rucom, legal_representative: true }
  end
end
