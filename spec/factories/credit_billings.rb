# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  unit                :string(255)
#  per_unit_value      :float
#  iva_value           :float
#  discount            :float
#  total_amount        :float
#  payment_flag        :boolean
#  payment_date        :datetime
#  discount_percentage :float
#  created_at          :datetime
#  updated_at          :datetime
#


FactoryGirl.define do
  factory :credit_billing do
    unit 200
    per_unit_value 1000
    payment_flag true
    payment_date Time.now
    discount_percentage 1.3
    user_id {FactoryGirl.create(:user).id}
  end

end
