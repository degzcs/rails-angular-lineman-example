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
    photo_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'image.png'),"image/jpeg") }
  end
end
