# == Schema Information
#
# Table name: population_centers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  longitude  :decimal(, )
#  latitude   :decimal(, )
#  city_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#  code       :string(255)
#

FactoryGirl.define do
  factory :population_center, class: PopulationCenter do
    sequence(:name) { |n| "population-center-#{n}" }
  	longitude { Faker::Address.longitude }
  	latitude { Faker::Address.latitude }
  	type { Faker::Hacker.abbreviation }
  	city { City.all.sample }
  	code { Faker::Number.number(6) }
  end

end
