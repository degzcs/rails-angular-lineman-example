FactoryGirl.define do

  factory :user, class: User  do |f|

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name}
    email { Faker::Internet.email }
    password 'foobar'
    document_number { Faker::Number.number(10) }
    document_expedition_date { Faker::Time.between(2.days.ago, Time.now) }
    phone_number { Faker::PhoneNumber.cell_phone }

  end
end