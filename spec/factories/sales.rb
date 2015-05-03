# == Schema Information
#
# Table name: sales
#
#  id                      :integer          not null, primary key
#  courier_id              :integer
#  client_id               :integer
#  user_id                 :integer
#  gold_batch_id           :integer
#  code                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  origin_certificate_file :string(255)
#  price                   :float
#

FactoryGirl.define do
  factory :sale do
    courier_id    1
    client_id     1
    user_id       1
    gold_batch 
    code       "12345677"
    price 123214521
  end
end
