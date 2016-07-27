FactoryGirl.define do
	factory :role, class: Role do |f|
    	name { Faker::Internet.email }
    end
end