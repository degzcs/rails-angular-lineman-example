require 'spec_helper'

describe 'all test the companies view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  it 'New Company and comapany alredy Exits' do
    visit '/admin/companies/new'
    expected_response = {
      nit: '900498208'
    }
    select('Comercializadores', from: 'company_name')
    select('NIT', from: 'company_address')
    fill_in 'company_nit_number', with: expected_response[:nit]
    VCR.use_cassette('create_trader_from_ui') do
      click_button('Create Company')
    end
    last_company = Company.order(:created_at).last
    last_rucom = Rucom.order(:created_at).last
    expect(last_company.nit_number).to eq expected_response[:nit]
    expect(last_company.rucom).to eq last_rucom
    expect(last_rucom.rucomeable_id).to eq last_company.id
    expect(last_rucom.rucomeable_type).to eq 'Company'
    expect(page).to have_content 'La compañia y el rucom de esta se han creado correctamente'
    # comapany alredy Exits
    visit '/admin/companies/new'
    select('Comercializadores', from: 'company_name')
    select('NIT', from: 'company_address')
    fill_in 'company_nit_number', with: '900498208'
    click_button('Create Company')
    expect(page).to have_content 'la compañia ya Existe!'
  end

  it 'complete company registration' do
    expected_response = {
      # user fields
      email: 'lam.ehbotas@thecompany.com',
      password: 'this_is_my_password',
      password_confirmation: 'this_is_my_password',
      # profile fields
      first_name: 'Lam',
      last_name: 'Ehbotas',
      document_number: '987654321',
      phone_number: '3004445566',
      available_credits: 0,
      address: 'Street fake 123',
      rut_file: "#{ Rails.root }/spec/support/pdfs/rut_file.pdf",
      photo_file: "#{ Rails.root }/spec/support/images/photo_file.png",
      mining_authorization_file: "#{ Rails.root }/spec/support/pdfs/mining_register_file.pdf",
      id_document_file: "#{ Rails.root }/spec/support/pdfs/document_number_file.pdf",
      nit_number: '12345676',
      # company fields
      name: 'Company test',
      email_company: 'compañia@gmail.com',
      phone_number_company: '45678683'
    }
    company = create(:company, name: nil, email: nil, phone_number: nil, chamber_of_commerce_file: nil, mining_register_file: nil, rut_file: nil)
    company.legal_representative.destroy!
    company.offices[0].destroy!
    company.update_column(:legal_representative_id, nil)
    company.reload
    visit '/admin/companies'
    within("#company_#{ company.id }") do
      click_link('Edit')
    end
    fill_in 'company_name', with: expected_response[:name]
    fill_in 'company_email', with: expected_response[:email_company]
    fill_in 'company_phone_number', with: expected_response[:phone_number_company]
    attach_file('company_chamber_of_commerce_file', expected_response[:mining_authorization_file])
    attach_file('company_rut_file', expected_response[:rut_file])
    attach_file('company_mining_register_file', expected_response[:mining_authorization_file])
    fill_in 'company_legal_representative_attributes_email', with: expected_response[:email]
    fill_in 'company_legal_representative_attributes_password', with: '12345678'
    fill_in 'company_legal_representative_attributes_password_confirmation', with: '12345678'
    fill_in 'company_legal_representative_attributes_profile_attributes_first_name', with: expected_response[:first_name]
    fill_in 'company_legal_representative_attributes_profile_attributes_last_name', with: expected_response[:last_name]
    fill_in 'company_legal_representative_attributes_profile_attributes_document_number', with: expected_response[:document_number]
    fill_in 'company_legal_representative_attributes_profile_attributes_phone_number', with: expected_response[:phone_number]
    fill_in 'company_legal_representative_attributes_profile_attributes_address', with: expected_response[:address]
    attach_file('company_legal_representative_attributes_profile_attributes_photo_file', expected_response[:photo_file])
    attach_file('company_legal_representative_attributes_profile_attributes_rut_file', expected_response[:rut_file])
    attach_file('company_legal_representative_attributes_profile_attributes_mining_authorization_file', expected_response[:mining_authorization_file])
    attach_file('company_legal_representative_attributes_profile_attributes_id_document_file', expected_response[:id_document_file])
    check('company_legal_representative_attributes_profile_attributes_legal_representative')
    fill_in 'company_legal_representative_attributes_profile_attributes_nit_number', with: expected_response[:nit_number]
    select('MEDELLIN', from: 'company_legal_representative_attributes_profile_attributes_city_id')

    click_button('Update Company')

    expect(company.reload.name).to eq expected_response[:name]
    expect(company.email).to eq expected_response[:email_company]
    expect(company.phone_number).to eq expected_response[:phone_number_company]
    expect(company.legal_representative.present?).to eq true
    expect(company.legal_representative.email).to eq expected_response[:email]
    expect(company.legal_representative.profile.first_name).to eq expected_response[:first_name]
    expect(company.legal_representative.profile.phone_number).to eq expected_response[:phone_number]
    expect(company.legal_representative.profile.nit_number).to eq expected_response[:nit_number]
    expect(company.legal_representative.profile.setting.present?).to eq true
    expect(company.legal_representative.completed?).to eq true
    expect(company.rucom.present?).to eq true
    expect(company.offices.present?).to eq true
    expect(company.completed?).to eq true
  end

  it 'Edit Company' do
    company = create(:company)
    legal_representative = company.legal_representative
    legal_representative.complete!
    expected_response = {
      company_name: 'compañia de prueba',
      legal_representative_name: 'Representante legal'
    }
    visit '/admin/companies'
    within("#company_#{company.id}") do
      click_link('Edit')
    end
    fill_in 'company_name', with: ''
    fill_in 'company_name', with: expected_response[:company_name]
    fill_in 'company_legal_representative_attributes_profile_attributes_first_name', with: expected_response[:legal_representative_name]
    click_button('Update Company')
    expect(company.reload.name).to eq expected_response[:company_name]
    expect(company.legal_representative.profile.first_name).to eq expected_response[:legal_representative_name]
    expect(company.legal_representative.completed?).to eq true
    expect(company.rucom.present?).to eq true
    expect(company.offices.present?).to eq true
    expect(company.completed?).to eq true
  end

  it 'Company Rucom Not Exits' do
    visit '/admin/companies/new'
    expected_response = {
      nit: '323232323'
    }
    select('Comercializadores', from: 'company_name')
    select('NIT', from: 'company_address')
    fill_in 'company_nit_number', with: expected_response[:nit]
    VCR.use_cassette('trader_rucom_does_not_exist_query') do
      click_button('Create Company')
    end
    expect(page).to have_content "Sincronize.call: error => El rucom no existe con este documento de identidad: #{expected_response[:nit]}"
  end

  it 'Company draft state' do
    company = create(:company, name: nil, email: nil, phone_number: nil, chamber_of_commerce_file: nil, mining_register_file: nil, rut_file: nil, nit_number: '1110001')
    company.legal_representative.destroy!
    company.update_column(:legal_representative_id, nil)
    company.offices[0].destroy!
    company.reload
    expected_response = {
      # user fields
      email: 'lam.ehbotas@thecompany.com',
      password: 'this_is_my_password',
      password_confirmation: 'this_is_my_password',
      # profile fields
      first_name: 'Lam',
      last_name: 'Ehbotas',
      document_number: '987654321',
      phone_number: '3004445566',
      available_credits: 0,
      address: 'Street fake 123',
      rut_file: "#{ Rails.root }/spec/support/pdfs/rut_file.pdf",
      photo_file: "#{ Rails.root }/spec/support/images/photo_file.png",
      mining_authorization_file: "#{ Rails.root }/spec/support/pdfs/mining_register_file.pdf",
      id_document_file: "#{ Rails.root }/spec/support/pdfs/document_number_file.pdf",
      nit_number: '12345676',
      # company fields
      address_company: 'calle 45 # 32',
      city: City.first.name,
      phone_number_company: '3445565'
    }
    visit '/admin/companies'
    within("#company_#{ company.id }") do
      click_link('Edit')
    end
    select(expected_response[:city], from: 'company_city_id')
    fill_in 'company_phone_number', with: expected_response[:phone_number_company]
    fill_in 'company_address', with: expected_response[:address_company]
    fill_in 'company_legal_representative_attributes_email', with: expected_response[:email]
    fill_in 'company_legal_representative_attributes_password', with: '12345678'
    fill_in 'company_legal_representative_attributes_password_confirmation', with: '12345678'
    fill_in 'company_legal_representative_attributes_profile_attributes_first_name', with: expected_response[:first_name]
    fill_in 'company_legal_representative_attributes_profile_attributes_last_name', with: expected_response[:last_name]
    fill_in 'company_legal_representative_attributes_profile_attributes_document_number', with: expected_response[:document_number]
    fill_in 'company_legal_representative_attributes_profile_attributes_phone_number', with: expected_response[:phone_number]
    fill_in 'company_legal_representative_attributes_profile_attributes_address', with: expected_response[:address]
    attach_file('company_legal_representative_attributes_profile_attributes_photo_file', expected_response[:photo_file])
    attach_file('company_legal_representative_attributes_profile_attributes_rut_file', expected_response[:rut_file])
    attach_file('company_legal_representative_attributes_profile_attributes_mining_authorization_file', expected_response[:mining_authorization_file])
    attach_file('company_legal_representative_attributes_profile_attributes_id_document_file', expected_response[:id_document_file])
    check('company_legal_representative_attributes_profile_attributes_legal_representative')
    fill_in 'company_legal_representative_attributes_profile_attributes_nit_number', with: expected_response[:nit_number]
    select('MEDELLIN', from: 'company_legal_representative_attributes_profile_attributes_city_id')

    click_button('Update Company')

    expect(company.reload.address).to eq expected_response[:address_company]
    expect(company.city.name).to eq expected_response[:city]
    expect(company.phone_number).to eq expected_response[:phone_number_company]
    expect(company.offices.present?).to eq true
    expect(company.rucom.present?).to eq true
    expect(company.legal_representative.present?).to eq true
    expect(company.legal_representative.completed?).to eq true
    expect(company.draft?).to eq true
  end

  it 'Company draft state a completed state' do
    expected_response = {
      name: 'Test',
      email: 'xxxx@gmail.com',
      phone_number: '3445565'
    }
    company = create(:company, name: nil, email: nil, phone_number: nil)
    company.pause
    company.legal_representative.complete!
    expect(company.draft?).to eq true
    visit '/admin/companies'
    within("#company_#{ company.id }") do
      click_link('Edit')
    end
    fill_in 'company_name', with: expected_response[:name]
    fill_in 'company_email', with: expected_response[:email]
    fill_in 'company_phone_number', with: expected_response[:phone_number]
    click_button('Update Company')
    expect(company.reload.name).to eq expected_response[:name]
    expect(company.email).to eq expected_response[:email]
    expect(company.phone_number).to eq expected_response[:phone_number]
    expect(company.completed?).to eq true
    expect(company.offices.present?).to eq true
    expect(company.rucom.present?).to eq true
    expect(company.legal_representative.present?).to eq true
    expect(company.legal_representative.completed?).to eq true
  end

  it 'When the company can not market oro' do
    visit '/admin/companies/new'
    expected_response = {
      nit: '900058021'
    }
    select('Comercializadores', from: 'company_name')
    select('NIT', from: 'company_address')
    fill_in 'company_nit_number', with: expected_response[:nit]
    click_button('Create Company')
    expect(page).to have_content 'Sincronize.call: error => Esta compañia no puede comercializar ORO'
  end
end
