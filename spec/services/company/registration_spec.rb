require 'spec_helper'

describe Company::Registration do
  let(:service) { Company::Registration.new }

  before :each do
    @rucom = create(:rucom)

    @legal_representative_data = {
      email: 'lam.ehbotas@thecompany.com',
      office_id: nil, # This will be updated after create both user and company records
      external: false,
      password: 'this_is_my_password',
      password_confirmation: 'this_is_my_password',
      profile_attributes: {
        first_name: 'Lam',
        last_name: 'Ehbotas',
        document_number: '987654321',
        phone_number: '3004445566',
        available_credits: 0,
        address: 'Street fake 123',
        id_document_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'document_number_file.pdf'), "application/pdf"),
        rut_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'), "application/pdf"), # this is need because this rut has to confirm that this person is a legal representative
        photo_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'), "image/jpeg"),
        mining_authorization_file: nil, # TODO: ask for it?
        legal_representative: true,
        city_id: City.last.id
      }
    }

    @company_data = {
      nit_number: '654321987',
      name: 'Fake Company SAS',
      city: City.find_by(name: 'MEDELLIN'),
      email: 'fake.company@thecompany.com',
      phone_number: '3001112233',
      chamber_of_commerce_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'chamber_of_commerce_file.pdf'), "application/pdf"),
      external: false, # ?
      rut_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'), "application/pdf"),
      mining_register_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'mining_register_file.pdf'), "application/pdf"),
      address: 'Street 123'
    }
  end

  it 'should create a company and its legal representative' do
    response = service.call(legal_representative_data: @legal_representative_data, company_data: @company_data, rucom: @rucom)
    expect(response[:success]).to be true
    expect(service.company).to be_persisted
    expect(service.legal_representative).to be_persisted
  end
end
