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
