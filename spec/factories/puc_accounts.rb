# == Schema Information
#
# Table name: puc_accounts
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :puc_account do
    code "MyString"
    name "MyString"
    debit "MyString"
    credit "MyString"
    account_nature "MyString"
  end
end
