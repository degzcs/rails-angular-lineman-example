require 'spec_helper'

describe 'all test the companies view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  it 'New Company and comapany alredy Exits' do
    visit '/admin/companies/new'
    expected_response = {
      nit: '900058021'
    }
    select('Comercializadores', from: 'company_name')
    select('NIT', from: 'company_address')
    fill_in 'company_nit_number', with: expected_response[:nit]
    click_button('Create Company')
    last_company = Company.order(:created_at).last
    last_rucom = Rucom.order(:created_at).last
    expect(last_company.nit_number).to eq expected_response[:nit]
    expect(last_company.rucom).to eq last_rucom
    expect(last_rucom.rucomeable_id).to eq last_company.id
    expect(last_rucom.rucomeable_type).to eq 'Company'
    # comapany alredy Exits
    visit '/admin/companies/new'
    select('Comercializadores', from: 'company_name')
    select('NIT', from: 'company_address')
    fill_in 'company_nit_number', with: '900058021'
    click_button('Create Company')
    expect(page).to have_content 'la compañia ya Existe!'
  end

  it 'Show Company' do
    # have this test is when implemented the state machine
  end
  # have this test is when implemented the state machine
  it 'Edit Company' do
    # company = create(:company)
    # expected_response = {
    #   company_name: 'compañia de prueba',
    #   password: '12345678',
    #   legal_representative_name: 'Representante legal'
    # }
    # visit '/admin/companies'
    # within("#company_#{company.id}") do
    #   click_link('Edit')
    # end
    # fill_in 'company_name', with: expected_response[:company_name]
    # fill_in 'company_legal_representative_attributes_password', with: expected_response[:password]
    # fill_in 'company_legal_representative_attributes_password_confirmation', with: expected_response[:password]
    # fill_in 'company_legal_representative_attributes_profile_attributes_first_name', with: expected_response[:legal_representative_name]
    # click_button('Update Company')
    # expect(company.reload.name).to eq expected_response[:company_name]
    # expect(company.legal_representative.profile.first_name).to eq expected_response[:legal_representative_name]
  end

  it 'Rucom Not Exits' do
    visit '/admin/companies/new'
    expected_response = {
      nit: '323232323'
    }
    select('Comercializadores', from: 'company_name')
    select('NIT', from: 'company_address')
    fill_in 'company_nit_number', with: expected_response[:nit]
    click_button('Create Company')
    expect(page).to have_content 'Rucom No Existe en la pagina ANM'
  end
end
