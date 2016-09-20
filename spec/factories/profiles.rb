# == Schema Information
#
# Table name: profiles
#
#  id                        :integer          not null, primary key
#  first_name                :string(255)
#  last_name                 :string(255)
#  document_number           :string(255)
#  phone_number              :string(255)
#  available_credits         :float
#  address                   :string(255)
#  rut_file                  :string(255)
#  photo_file                :string(255)
#  mining_authorization_file :text
#  legal_representative      :boolean
#  id_document_file          :text
#  nit_number                :string(255)
#  city_id                   :integer
#  created_at                :datetime
#  updated_at                :datetime
#  user_id                   :integer
#

FactoryGirl.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name}
    document_number { Faker::Number.number(10) }
    phone_number { Faker::PhoneNumber.cell_phone }
    available_credits { 0 }
    address { Faker::Address.street_address}
    rut_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'),"application/pdf") }
    photo_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'),"image/jpeg") }
    mining_authorization_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'mining_register_file.pdf'),"application/pdf") }
    legal_representative { false }
    id_document_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'document_number_file.pdf'),"application/pdf") }
    nit_number { Faker::Number.number(10) }
    city { City.all.sample }
  end
end
