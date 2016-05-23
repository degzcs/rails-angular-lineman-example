require 'spec_helper'

describe Company::Registration do

  let(:service){ Company::Registration.new }
  before :each do
    @rucom = create(:rucom)

    @legal_representative_data = {
      first_name: 'Lam',
      last_name: 'Ehbotas',
      email: 'lam.ehbotas@thecompany.com',
      document_number: '987654321',
      document_expedition_date: 10.years.ago,
      phone_number: '3004445566',
      password: 'this_is_my_password',
      password_confirmation: 'this_is_my_password',
      available_credits: 0,
      address: 'Street fake 123',
      document_number_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'document_number_file.pdf'),"application/pdf"),
      rut_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'),"application/pdf"), # this is need because this rut has to confirm that this person is a legal representative
      photo_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'),"image/jpeg"),
      office_id: nil, # This will be updated after create both user and company records
      external: false,
      mining_register_file: nil, # TODO: ask for it?
      legal_representative: true,
    }

    @company_data = {
      nit_number: '654321987',
      name: 'Fake Company SAS',
      city: 'ATIOQUIA',
      state: 'MEDELLIN',
      country: 'COLOMBIA',
      email: 'fake.company@thecompany.com',
      phone_number: '3001112233',
      chamber_of_commerce_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'chamber_of_commerce_file.pdf'),"application/pdf"),
      external: false, #?
      rut_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'),"application/pdf"),
      mining_register_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'mining_register_file.pdf'),"application/pdf"),
    }
  end

  it 'should create a company and its legal representative' do
    reponse = service.call(legal_representative_data: @legal_representative_data, company_data: @company_data, rucom: @rucom)
    expect(reponse[:success]).to be true
    expect(service.company).to be_persisted
    expect(service.legal_representative).to be_persisted
  end
end