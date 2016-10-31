require 'spec_helper'

describe 'all test the roles view', :js do
  before :each do
    rol = Role.find_by(name: 'RolPrueba')
    rol.destroy! if rol.present?
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  it 'Create new Rol' do
    visit '/admin/roles/new'
    expected_response = {
      name: 'RolPrueba'
    }
    fill_in 'Name*', with: expected_response[:name]
    click_button('Create Role')
    last_rol = Role.order(:created_at).last.as_json.with_indifferent_access
    expect(last_rol[:name]).to eq expected_response[:name]
    expect(page).to have_content 'Role was successfully created.'
  end

  it 'Edit Rol' do
    expected_response = {
      name: 'RolPrueba'
    }
    role = Role.create(name: 'RolPrueba')
    visit '/admin/roles/'
    within("#role_#{role.id}") do
      click_link('Edit')
    end
    # update admin_user with new info
    fill_in 'Name*', with: ' '
    fill_in 'Name*', with: expected_response[:name]
    click_button('Update Role')
    expect(role.reload.name).to eq expected_response[:name]
  end

  it 'Show Rol' do
    role = Role.create(name: 'RolPrueba')
    visit '/admin/roles/'
    within("#role_#{role.id}") do
      click_link('View')
    end
    expect(page).to have_content 'RolPrueba'
  end

  it 'Destroy Rol' do
    role = Role.create(name: 'RolPrueba')
    visit '/admin/roles/'
    within("#role_#{role.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Role was successfully destroyed.'
  end

  it 'Test button Batch Actions' do
    role = Role.create(name: 'RolPrueba')
    visit '/admin/roles/'
    check("batch_action_item_#{role.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 role'
  end
end
