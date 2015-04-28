# == Schema Information
#
# Table name: sales
#
#  id            :integer          not null, primary key
#  courier_id    :integer
#  client_id     :integer
#  user_id       :integer
#  gold_batch_id :integer
#  grams         :float
#  code          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryGirl.define do
  factory :sale do
    courier_id    1
    client_id     1
    user_id       1
    gold_batch_id 1
    grams         200
    code       "12345677"
  end
end
