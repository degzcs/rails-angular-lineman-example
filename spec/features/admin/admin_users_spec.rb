require 'spec_helper'

describe 'all test the admin_user view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  after :each do
    admin_user = AdminUser.find_by(email: 'adminuser@prueba.com')
    admin_user.destroy! if admin_user.present?
  end

  it 'Create New AdminUser' do
    visit '/admin/admin_users/new'
    expected_response = {
      email: 'adminuser@prueba.com',
      password: '12345678'
    }
    fill_in 'Email*', with: expected_response[:email]
    fill_in 'Password*', with: expected_response[:password]
    fill_in 'Password confirmation', with: expected_response[:password]
    click_button('Create Admin user')
    last_admin_user = AdminUser.order(:created_at).last.as_json.with_indifferent_access
    expect(last_admin_user[:email]).to eq expected_response[:email]
    expect(page).to have_content 'Admin user was successfully created.'
  end

  it 'Edit Admin User' do
    expected_response = {
      email: 'adminuser@prueba.com',
      password: '123123123'
    }
    admin_user = AdminUser.create(email: 'adminuser@prueba.com', password: '123123123', password_confirmation: '123123123')
    visit '/admin/admin_users/'
    within("#admin_user_#{admin_user.id}") do
      click_link('Edit')
    end
    # update admin_user with new info
    fill_in 'Email*', with: ' '
    fill_in 'Email*', with: expected_response[:email]
    fill_in 'Password*', with: expected_response[:password]
    fill_in 'Password confirmation', with: expected_response[:password]
    click_button('Update Admin user')
    expect(admin_user.reload.email).to eq expected_response[:email]
  end

  it 'Show AdminUser' do
    admin_user = AdminUser.create(email: 'adminuser@prueba.com', password: '123123123', password_confirmation: '123123123')
    visit '/admin/admin_users/'
    within("#admin_user_#{admin_user.id}") do
      click_link('View')
    end
    expect(page).to have_content 'adminuser@prueba.com'
  end

  it 'Destroy AdminUser' do
    admin_user = AdminUser.create(email: 'adminuser@prueba.com', password: '123123123', password_confirmation: '123123123')
    visit '/admin/admin_users/'
    within("#admin_user_#{admin_user.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Admin user was successfully destroyed.'
  end

  it 'Test button Batch Actions' do
    admin_user = AdminUser.create(email: 'adminuser@prueba.com', password: '123123123', password_confirmation: '123123123')
    visit '/admin/admin_users/'
    check("batch_action_item_#{admin_user.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 admin user'
  end
end
