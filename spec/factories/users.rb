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
#  reset_token              :string(255)
#  address                  :string(255)
#  document_number_file     :string(255)
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  photo_file               :string(255)
#  chamber_commerce_file    :string(255)
#  rucom_id                 :integer
#  company_id               :integer
#  population_center_id     :integer
#  user_type                :integer          default(1), not null
#

FactoryGirl.define do

  factory :user do |f|
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name}
    email { Faker::Internet.email }
    document_number { Faker::Number.number(10) }
    document_expedition_date 50.years.ago
    phone_number { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_address}
    document_number_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'photo_file.png'),"image/jpeg") }
    rut_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'photo_file.png'),"image/jpeg") }
    mining_register_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'photo_file.png'),"image/jpeg") }
    photo_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'photo_file.png'),"image/jpeg") }
    chamber_commerce_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'photo_file.png'),"image/jpeg") }
    user_type 1
    rucom
    company
    population_center
    password {'foobar'}
    password_confirmation {'foobar'}
  end
end
