# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  provider_id                 :integer
#  origin_certificate_sequence :string(255)
#  gold_batch_id               :integer
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#  seller_picture              :string(255)
#

FactoryGirl.define do
  factory :purchase do
    user_id {FactoryGirl.create(:user).id}
    provider_id 1
    origin_certificate_sequence {Faker::Code.isbn}
    gold_batch {FactoryGirl.create(:gold_batch)}
    price 1.5
    origin_certificate_file {"MyString"}
  end

end
