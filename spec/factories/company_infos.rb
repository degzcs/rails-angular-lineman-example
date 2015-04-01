FactoryGirl.define do
  factory :company_info, class: CompanyInfo do |f|
    nit_number { Faker::Number.number(10) }
    name {Faker::Company.name}
    city {Faker::Address.city}
    state {Faker::Address.state}
    country {Faker::Address.country}
    legal_representative {Faker::Name.name}
    id_type_legal_rep { Faker::Number.number(10)}
    email {Faker::Internet.email}
    phone_number {Faker::PhoneNumber.phone_number}
    provider_id {"id"}
  end
end
