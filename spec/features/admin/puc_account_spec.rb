require 'spec_helper'

describe 'all test the puc_accounts view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  after :each do
    puc_account = PucAccount.last
    puc_account.destroy! if puc_account.present?
  end

  it 'New PucAccount' do
    visit '/admin/puc_accounts/new'
    expected_response = {
      code: '2100',
      name: 'CxP Cuentas por pagar - prueba'
    }
    fill_in 'puc_account_code', with: expected_response[:code]
    fill_in 'puc_account_name', with: expected_response[:name]
    click_button('Create Puc account')
    las_puc_account = PucAccount.order(:created_at).last.as_json.with_indifferent_access
    expect(las_puc_account[:code]).to eq expected_response[:code]
    expect(las_puc_account[:name]).to eq expected_response[:name]
    expect(page).to have_content 'Puc account was successfully created.'
  end

  it 'Edit PucAccount' do
    expected_response = {
      code: '211001'
    }
    puc_account = PucAccount.create(code: '2110', name: 'CxP prueba')
    visit '/admin/puc_accounts'
    within("#puc_account_#{puc_account.id}") do
      click_link('Edit')
    end
    # update admin_user with new info
    fill_in 'puc_account_code', with: ' '
    fill_in 'puc_account_code', with: expected_response[:code]
    click_button('Update Puc account')
    expect(puc_account.reload.code).to eq expected_response[:code]
  end

  it 'Show PucAccount' do
    puc_account = PucAccount.create(code: '1100', name: 'Caja - prueba')
    visit '/admin/puc_accounts'
    within("#puc_account_#{puc_account.id}") do
      click_link('View')
    end
    expect(page).to have_content puc_account.name
  end

  it 'Destroy PucAccount' do
    puc_account = PucAccount.create(code: '1100', name: 'Caja - prueba')
    visit '/admin/puc_accounts'
    within("#puc_account_#{puc_account.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Puc account was successfully destroyed'
  end

  it 'Test button Batch Actions' do
    puc_account = PucAccount.create(code: '1100', name: 'Caja - prueba')
    visit '/admin/puc_accounts/'
    check("batch_action_item_#{puc_account.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 puc account'
  end
end
