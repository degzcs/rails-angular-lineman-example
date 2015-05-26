# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  state_code :string(255)      not null
#  city_code  :string(255)      not null
#

FactoryGirl.define do
  factory :city , class: City do
  name { Faker::Address.city }
	state_id {Random.rand(1...100)} 
	city_code { Faker::Number.number(6) }
	state_code { Faker::Number.number(6) }
  end

end
