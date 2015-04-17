# == Schema Information
#
# Table name: clients
#
#  id                   :integer          not null, primary key
#  first_name           :string(255)
#  last_name            :string(255)
#  phone_number         :string(255)
#  company_name         :string(255)
#  address              :string(255)
#  nit_company_number   :string(255)
#  id_document_type     :string(255)
#  id_document_number   :string(255)
#  client_type          :string(255)
#  rucom_id             :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  population_center_id :integer
#  email                :string(255)
#

FactoryGirl.define do
  factory :client do
    first_name { Faker::Name.first_name }
	last_name { Faker::Name.first_name }
	phone_number { Faker::PhoneNumber.phone_number }
	company_name {Faker::Company.name}
	address { Faker::Address.street_address}
	nit_company_number { Faker::Number.number(10) }
	id_document_type { Faker::Hacker.abbreviation }
	id_document_number { Faker::Number.number(10) }
	client_type { Faker::Hacker.abbreviation }
	rucom_id {Random.rand(1...100)}
	email {Faker::Internet.email}
	population_center_id {Random.rand(1...100)}
  end

end
