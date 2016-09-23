require 'spec_helper'

describe Company::Registration do
  let(:service) { Company::Registration.new }
  let(:company) { create :company }
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

  it 'should associate the company with legal representative' do
    company.legal_representative.destroy!
    company.offices[0].destroy!
    company.update_column(:legal_representative_id, nil)
    company.reload
    @company_data = company.as_json.except!('created_at', 'updated_at')
    response = service.call(legal_representative_data: @legal_representative_data, company_data: @company_data)
    expect(response[:success]).to be true
    expect(service.company.legal_representative.present?).to be true
    expect(service.company.rucom.present?).to be true
    expect(service.company.offices.present?).to be true
    expect(service.legal_representative).to be_persisted
    expect(service.legal_representative.profile).to be_persisted
    expect(service.legal_representative.roles[0][:name]).to eq 'trader'
    expect(service.company.completed?).to eq true
  end

  it 'update company and legal_representative' do
    email = company.legal_representative.email
    user_id = company.legal_representative.id
    company_id = company.id
    @legal_representative_data.delete(:email)
    @legal_representative_data[:email] = email
    @legal_representative_data[:id] = user_id

    @company_data = {
      id: company_id,
      name: 'Test',
      email: 'xxxxx@gmail.com',
      phone_number: '55555555'
    }

    response = service.call(legal_representative_data: @legal_representative_data, company_data: @company_data)
    expect(response[:success]).to be true
    expect(service.company.legal_representative.reload.profile.first_name).to eq @legal_representative_data[:profile_attributes][:first_name]
    expect(service.company.legal_representative.profile.last_name).to eq @legal_representative_data[:profile_attributes][:last_name]
    expect(service.company.legal_representative.profile.address).to eq @legal_representative_data[:profile_attributes][:address]
    expect(service.company.reload.name).to eq 'Test'
    expect(service.company.email).to eq 'xxxxx@gmail.com'
    expect(service.company.phone_number).to eq '55555555'
    expect(service.company.completed?).to eq true
  end

  it 'Company in draft state' do
    compani = create(:company, name: nil, phone_number: nil, email: nil)
    @company_data = compani.as_json.except!('created_at', 'updated_at')
    response = service.call(legal_representative_data: @legal_representative_data, company_data: @company_data)
    expect(response[:success]).to be true
    expect(service.company.draft?).to eq true
  end
end
