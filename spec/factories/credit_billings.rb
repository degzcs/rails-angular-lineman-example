# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  unit                :integer
#  per_unit_value      :float
#  payment_flag        :boolean          default(FALSE)
#  payment_date        :datetime
#  discount_percentage :float            default(0.0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  total_amount        :float            default(0.0), not null
#  discount            :float            default(0.0), not null
#

FactoryGirl.define do
  factory :credit_billing do
    unit { 10 }
    per_unit_value { 1000 }
    payment_flag true
    payment_date { Time.now }
    discount_percentage { 0 }
    user { create :user, :with_profile, :with_personal_rucom, legal_representative: true }
  end
end
