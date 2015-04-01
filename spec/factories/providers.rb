FactoryGirl.define do
  factory :provider , class: Provider do
    document_number { Faker::Number.number(10)}
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::Name.first_name }
    address { Faker::Address.street_address}
    company_info {FactoryGirl.build(:company_info)}
    rucom {FactoryGirl.create(:rucom)}
  end
end
