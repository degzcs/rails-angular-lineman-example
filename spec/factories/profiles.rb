FactoryGirl.define do
  factory :profile do
    document_number { Faker::Number.number(10) }
    phone_number { Faker::PhoneNumber.cell_phone }
    avaible_credits { 0 }
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
