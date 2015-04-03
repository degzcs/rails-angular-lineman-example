# == Schema Information
#
# Table name: population_centers
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  longitude              :decimal(, )
#  latitude               :decimal(, )
#  type                   :string(255)
#  city_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  population_center_code :string(255)      not null
#  city_code              :string(255)      not null
#

FactoryGirl.define do
  factory :population_center, class: PopulationCenter do
    name { Faker::Address.city }
	longitude { Faker::Address.longitude }
	latitude { Faker::Address.latitude }
	type { Faker::Hacker.abbreviation }
	city_id {Random.rand(1...100)}
	population_center_code { Faker::Number.number(6) } 
	city_code { Faker::Number.number(6) }
  end

end
