# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
	factory :role, class: Role do |f|
    	name { Faker::Internet.email }
    end
end
