require 'spec_helper'

describe Company::Registration do
  let(:service) { Company::Registration.new }
  let(:company) { create :company, legal_representative: nil, offices: [] }
  before :each do
    @legal_representative_data = {
      email: 'lam.ehbotas@thecompany.com',
      password: 'this_is_my_password',
      password_confirmation: 'this_is_my_password',
      profile_attributes: {
        first_name: 'Lam',
        last_name: 'Ehbotas',
        document_number: '987654321',
        phone_number: '3004445566',
        available_credits: 0,
        address: 'Street fake 123',
        id_document_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'document_number_file.pdf'), 'application/pdf'),
        rut_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'), 'application/pdf'),
        photo_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'), 'image/jpeg'),
        mining_authorization_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'mining_register_file.pdf'), 'application/pdf'),
        legal_representative: '1',
        nit_number: '12345676',
        city_id: City.last.id
      }
    }
    @legal_representative_data.as_json
  end

  it 'should create a company and its legal representative' do
    @company_data = company.as_json.except!('created_at', 'updated_at')
    response = service.call(legal_representative_data: @legal_representative_data, company_data: @company_data)
    expect(response[:success]).to be true
    expect(service.company.legal_representative.present?).to be true
    expect(service.company.rucom.present?).to be true
    expect(service.company.offices.present?).to be true
    expect(service.legal_representative).to be_persisted
    expect(service.legal_representative.roles[0][:name]).to eq 'trader'
  end
end
