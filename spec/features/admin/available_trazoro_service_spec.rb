describe 'all test the available_trazoro_services view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  it 'Create new trazoro service' do
    visit '/admin/available_trazoro_services/new'
    expected_response = {
      name: 'test',
      credits: 2.3,
      reference: 'buy_test'
    }
    fill_in 'available_trazoro_service_name', with: expected_response[:name]
    fill_in 'available_trazoro_service_credits', with: expected_response[:credits]
    fill_in 'available_trazoro_service_reference', with: expected_response[:reference]
    click_button('Create Available trazoro service')
    last_trazoro_service = AvailableTrazoroService.order(:created_at).last.as_json.with_indifferent_access
    expect(last_trazoro_service[:name]).to eq expected_response[:name]
    expect(last_trazoro_service[:credits]).to eq expected_response[:credits]
    expect(last_trazoro_service[:reference]).to eq expected_response[:reference]
    expect(page).to have_content 'Available trazoro service was successfully created.'
  end

  it 'Edit a trazoro service' do
    expected_response = {
      name: 'registro barequero',
      credits: 5
    }
    service_trazoro = create(:available_trazoro_service)
    visit '/admin/available_trazoro_services'
    within("#available_trazoro_service_#{service_trazoro.id}") do
      click_link('Edit')
    end
    fill_in 'available_trazoro_service_name', with: expected_response[:name]
    fill_in 'available_trazoro_service_credits', with: expected_response[:credits]
    click_button('Update Available trazoro service')
    expect(service_trazoro.reload.name).to eq expected_response[:name]
    expect(service_trazoro.reload.credits).to eq expected_response[:credits]
  end

  it 'Show service trazoro' do
    service_trazoro = create(:available_trazoro_service)
    visit '/admin/available_trazoro_services'
    within("#available_trazoro_service_#{service_trazoro.id}") do
      click_link('View')
    end
    expect(page).to have_content "#{service_trazoro.name}"
  end

  it 'Destroy service trazoro' do
    service_trazoro = create(:available_trazoro_service)
    visit '/admin/available_trazoro_services'
    within("#available_trazoro_service_#{service_trazoro.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Available trazoro service was successfully destroyed.'
  end

  it 'Test button Batch Actions' do
    service_trazoro = create(:available_trazoro_service)
    visit '/admin/available_trazoro_services'
    check("batch_action_item_#{service_trazoro.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 available trazoro service'
  end
end
