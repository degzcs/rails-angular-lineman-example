# == Schema Information
#
# Table name: available_trazoro_services
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  credist    :float
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :available_trazoro_service do
    name "MyString"
    credist 1.5
  end
end
