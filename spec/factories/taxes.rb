# == Schema Information
#
# Table name: taxes
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  reference      :string(255)
#  porcent        :float
#  puc_account_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

FactoryGirl.define do
  factory :tax do
    name "MyString"
    initials "MyString"
    porcent 1.5
    puc_account nil
  end
end
