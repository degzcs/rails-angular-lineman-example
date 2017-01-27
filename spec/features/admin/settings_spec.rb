require 'spec_helper'

describe 'all test the settings view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  after :each do
    setting = Settings.last
    setting.destroy! if setting.present?
  end

  it 'New Setting' do
    visit '/admin/settings/new'
    expected_response = {
      monthly_threshold: '20',
      fine_gram_value: '1000',
      vat_percentage: '16',
      fixed_sale_agreetment: 'fixed sale agreetment text',
      habeas_data_agreetment: 'habeas agreetment text',
      ros_threshold: '2000000'
    }
    fill_in 'settings_monthly_threshold', with: expected_response[:monthly_threshold]
    fill_in 'settings_vat_percentage', with: expected_response[:vat_percentage]
    fill_in 'settings_fine_gram_value', with: expected_response[:fine_gram_value]
    fill_in 'settings_fixed_sale_agreetment', with: expected_response[:fixed_sale_agreetment]
    fill_in 'settings_habeas_data_agreetment', with: expected_response[:habeas_data_agreetment]
    fill_in 'settings_ros_threshold', with: expected_response[:ros_threshold]
    click_button('Create Settings')
    last_setting = Settings.order(:created_at).last.as_json.with_indifferent_access
    expect(last_setting[:data][:monthly_threshold]).to eq expected_response[:monthly_threshold]
    expect(last_setting[:data][:fine_gram_value]).to eq expected_response[:fine_gram_value]
    expect(last_setting[:data][:vat_percentage]).to eq expected_response[:vat_percentage]
    expect(last_setting[:data][:fixed_sale_agreetment]).to eq expected_response[:fixed_sale_agreetment]
    expect(last_setting[:data][:habeas_data_agreetment]).to eq expected_response[:habeas_data_agreetment]
    expect(last_setting[:data][:ros_threshold]).to eq expected_response[:ros_threshold]
    expect(page).to have_content 'Settings was successfully created.'
  end

  it 'Edit Setting' do
    expected_response = {
      monthly_threshold: '30'
    }
    settings = Settings.create(monthly_threshold: 10, fine_gram_value: 100, vat_percentage: 16)
    visit '/admin/settings'
    within("#settings_#{settings.id}") do
      click_link('Edit')
    end
    # update admin_user with new info
    fill_in 'settings_monthly_threshold', with: ' '
    fill_in 'settings_monthly_threshold', with: expected_response[:monthly_threshold]
    click_button('Update Settings')
    expect(settings.reload.monthly_threshold).to eq expected_response[:monthly_threshold]
  end

  it 'Show Setting' do
    settings = Settings.create(monthly_threshold: 10, fine_gram_value: 100, vat_percentage: 16)
    visit '/admin/settings'
    within("#settings_#{settings.id}") do
      click_link('View')
    end
    expect(page).to have_content "Settings ##{settings.id}"
  end

  it 'Destroy Setting' do
    settings = Settings.create(monthly_threshold: 10, fine_gram_value: 100, vat_percentage: 16)
    visit '/admin/settings'
    within("#settings_#{settings.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Settings was successfully destroyed'
  end

  it 'Test button Batch Actions' do
    settings = Settings.create(monthly_threshold: 10, fine_gram_value: 100, vat_percentage: 16)
    visit '/admin/settings/'
    check("batch_action_item_#{settings.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 setting'
  end
end
