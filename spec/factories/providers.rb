# == Schema Information
#
# Table name: providers
#
#  id              :integer          not null, primary key
#  document_number :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  phone_number    :string(255)
#  address         :string(255)
#  email         :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  rucom_id        :integer
#

FactoryGirl.define do
  factory :provider , class: Provider do
    document_number { Faker::Number.number(10)}
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.phone_number }
    address { Faker::Address.street_address}
    email {Faker::Internet.email}
    company_info {FactoryGirl.build(:company_info)}
    rucom_id {Random.rand(1...100)}
  end
end
