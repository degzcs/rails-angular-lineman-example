FactoryGirl.define do
  factory :order do
    buyer_id 1
    seller_id 1
    type ""
    code "MyString"
    price "MyString"
    trazoro false
  end
end
