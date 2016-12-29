# == Schema Information
#
# Table name: transaction_movements
#
#  id             :integer          not null, primary key
#  puc_account_id :integer
#  type           :string(255)
#  block_name     :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  afectation     :string(255)
#

FactoryGirl.define do
  factory :transaction_movement do
    puc_account nil
    type ""
    block_name "MyString"
  end
end
