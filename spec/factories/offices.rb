# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :office do
    name "Office name"
    company
  end

end
