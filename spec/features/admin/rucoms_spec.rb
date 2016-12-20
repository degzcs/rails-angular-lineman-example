require 'spec_helper'

describe 'all test the rucom view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  it 'New Rucom and rucom alredy Exits' do
    visit '/admin/rucoms/new'
    expected_response = {
      rol: 'Barequero',
      type_identification: 'CEDULA',
      identification_number: '15535725'
    }
    select(expected_response[:rol], from: 'rucom_name')
    select(expected_response[:type_identification], from: 'rucom_provider_type')
    fill_in 'rucom_rucom_number', with: expected_response[:identification_number]
    VCR.use_cassette('successful_rucom_creation_from_ui') do
      click_button('Create Rucom')
    end
    last_rucom = Rucom.order(:created_at).last.as_json.with_indifferent_access
    last_user = User.order(:created_at).last
    expect(last_rucom[:rucomeable_id]).to eq last_user.id
    expect(last_rucom[:name]).to eq last_user.profile.first_name
    expect(last_user.profile.document_number).to eq expected_response[:identification_number]
    expect(page).to have_content 'El rucom y el usuario se han creado correctamente'
    # Rucom(user) alredy Exits
    visit '/admin/rucoms/new'
    select(expected_response[:rol], from: 'rucom_name')
    select(expected_response[:type_identification], from: 'rucom_provider_type')
    fill_in 'rucom_rucom_number', with: expected_response[:identification_number]
    click_button('Create Rucom')
    expect(page).to have_content 'El rucom(usuario) ya Existe!'
  end

  # it 'Edit Rucom' do
  #   user_with_rucom = create(:user, :with_profile, :with_personal_rucom)
  #   expected_response = {
  #     location: 'MEDELLIN'
  #   }
  #   visit '/admin/rucoms/'
  #   within("#rucom_#{ user_with_rucom.rucom.id }") do
  #     click_link('Edit')
  #   end
  #   fill_in 'rucom_location', with: ' '
  #   fill_in 'rucom_location', with: expected_response[:location]
  #   click_button('Update Rucom')
  #   expect(user_with_rucom.reload.rucom.location).to eq expected_response[:location]
  # end

  # it 'Show Rucom' do
  #   user_with_rucom = create(:user, :with_profile, :with_personal_rucom)
  #   visit '/admin/rucoms/'
  #   within("#rucom_#{ user_with_rucom.rucom.id }") do
  #     click_link('View')
  #   end
  #   expect(page).to have_content "#{user_with_rucom.rucom.name}"
  # end

  it 'Rucom not exist in the page ANM' do
    VCR.use_cassette('barequero_not_exist_in_rucom_anm') do
      visit '/admin/rucoms/new'
      expected_response = {
        rol: 'Barequero',
        type_identification: 'CEDULA',
        identification_number: '1036661567'
      }
      select(expected_response[:rol], from: 'rucom_name')
      select(expected_response[:type_identification], from: 'rucom_provider_type')
      fill_in 'rucom_rucom_number', with: expected_response[:identification_number]
      click_button('Create Rucom')
      expect(page).to have_content "Sincronize.call: error => El rucom no existe con este documento de identidad: #{expected_response[:identification_number]}"
    end
  end

  xit 'When the Rucom(user) can not market oro' do
    visit '/admin/rucoms/new'
    expected_response = {
      identification_number: ' '
    }
    select('Barequero', from: 'rucom_name')
    select('CEDULA', from: 'rucom_provider_type')
    fill_in 'rucom_rucom_number', expected_response[:identification_number]
    click_button('Create Rucom')
    expect(page).to have_content 'Sincronize.call: error => Este productor no puede comercializar ORO'
  end
end
