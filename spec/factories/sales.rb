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
#  barcode       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  barcode_html  :string(255)
#

FactoryGirl.define do

  factory :sale do
    courier_id    1
    client_id     1
    user_id       1
    gold_batch_id 1
    grams         200
    barcode       "12345677"
    barcode_html       "TABLE"
  end

end
