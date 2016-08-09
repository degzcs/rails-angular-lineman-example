# == Schema Information
#
# Table name: company_infos
#
#  id                   :integer          not null, primary key
#  nit_number           :string(255)
#  name                 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country              :string(255)
#  legal_representative :string(255)
#  id_type_legal_rep    :string(255)
#  email                :string(255)
#  phone_number         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  provider_id          :integer
#  id_number_legal_rep  :string(255)
#

FactoryGirl.define do
  factory :company do |f|
    nit_number { Faker::Number.number(10) }
    name { Faker::Company.name }
    city { City.first }
    legal_representative { create :user, :with_profile, office: nil, legal_representative: true }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    chamber_of_commerce_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'),"image/jpeg") }
    mining_register_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'mining_register_file.pdf'),"application/pdf") }
    rut_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'),"application/pdf") }
    rucom
    address { 'Street 123' }

    after :create do |company, e|
      company.legal_representative.update_column :office_id, company.main_office.id
    end

  end
end
