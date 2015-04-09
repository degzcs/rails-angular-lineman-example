# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  first_name               :string(255)
#  last_name                :string(255)
#  email                    :string(255)
#  document_number          :string(255)
#  document_expedition_date :date
#  phone_number             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  password_digest          :string(255)
#  available_credits        :float
#

FactoryGirl.define do

  factory :user, class: User  do |f|

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name}
    email { Faker::Internet.email }
    password {'foobar'}
    password_confirmation {'foobar'}
    document_number { Faker::Number.number(10) }
    document_expedition_date { Faker::Time.between(2.days.ago, Time.now) }
    phone_number { Faker::PhoneNumber.cell_phone }
    
  end
end
