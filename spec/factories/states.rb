# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  country_id :integer
#  code       :string(255)
#

FactoryGirl.define do
  factory :state , class: State do
    sequence(:name) { |n| "state-#{n}" }
    code { Faker::Number.number(6) }
  end
end
