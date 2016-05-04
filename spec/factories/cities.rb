# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  code       :string(255)
#

FactoryGirl.define do
  factory :city , class: City do
    sequence(:name) { |n| "city-#{n}" }
    state
    code { Faker::Number.number(6) }
  end
end
