# == Schema Information
#
# Table name: external_users
#
#  id                       :integer          not null, primary key
#  document_number          :string(255)
#  first_name               :string(255)
#  last_name                :string(255)
#  phone_number             :string(255)
#  address                  :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  rucom_id                 :integer
#  document_number_file     :string(255)
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  photo_file               :string(255)
#  email                    :string(255)
#  population_center_id     :integer
#  chamber_commerce_file    :string(255)
#  company_id               :integer
#  document_expedition_date :date
#

FactoryGirl.define do
  factory :external_user  do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name}
    email { Faker::Internet.email }
    document_number { Faker::Number.number(10) }
    document_expedition_date 50.years.ago
    phone_number { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_address}
    document_number_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'provider_photo.png'),"image/jpeg") }
    rut_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'provider_photo.png'),"image/jpeg") }
    mining_register_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'provider_photo.png'),"image/jpeg") }
    photo_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'provider_photo.png'),"image/jpeg") }
    chamber_commerce_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'provider_photo.png'),"image/jpeg") }
    rucom
    company
    population_center
  end
end
