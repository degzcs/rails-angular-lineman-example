# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  state_code :string(255)      not null
#  country_id :integer
#

FactoryGirl.define do
  factory :state , class: State do
    name { Faker::Address.state }
    state_code { Faker::Number.number(6) }
  end
end
