# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  buyer_id       :integer
#  seller_id      :integer
#  courier_id     :integer
#  type           :string(255)
#  code           :string(255)
#  price          :string(255)
#  seller_picture :string(255)
#  trazoro        :boolean          default(FALSE), not null
#  boolean        :boolean          default(FALSE), not null
#  created_at     :datetime
#  updated_at     :datetime
#

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
