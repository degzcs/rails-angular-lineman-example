require 'spec_helper'

describe 'all test the taxes view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
    puc_account = PucAccount.create(code: '135595', name: 'ANTICIPO CREE (.40%)')
  end

  after :each do
    tax = Tax.last
    tax.destroy! if tax.present?
  end

  it 'New Tax' do
    visit '/admin/taxes/new'
    expected_response = {
      name: 'Anticipo CREE',
      reference: 'ANT_CREE',
      porcent: 0.4,
      puc_account: {id: PucAccount.accounts_for_select.last[1], select_name: PucAccount.accounts_for_select.last[0] }
    }
    fill_in 'tax_name', with: expected_response[:name]
    fill_in 'tax_reference', with: expected_response[:reference]
    fill_in 'tax_porcent', with: expected_response[:porcent]
    select(expected_response[:puc_account][:select_name], from: 'tax_puc_account_id')
    click_button('Create Tax')
    las_tax = Tax.order(:created_at).last.as_json.with_indifferent_access
    expect(las_tax[:name]).to eq expected_response[:name]
    expect(las_tax[:reference]).to eq expected_response[:reference]
    expect(las_tax[:porcent]).to eq expected_response[:porcent]
    expect(las_tax[:puc_account_id]).to eq expected_response[:puc_account][:id]

    expect(page).to have_content 'Tax was successfully created.'
  end

  it 'Edit Tax' do
    expected_response = {
      name: 'IVA - prueba'
    }
    tax = Tax.create(name: 'ANTICIPO CREE (.40%)', reference: 'ANT_CREE', porcent: 0.40 , puc_account_id: PucAccount.last.id)
    visit '/admin/taxes'
    within("#tax_#{tax.id}") do
      click_link('Edit')
    end
    # update admin_user with new info
    fill_in 'tax_name', with: ' '
    fill_in 'tax_name', with: expected_response[:name]
    click_button('Update Tax')
    expect(tax.reload.name).to eq expected_response[:name]
  end

  it 'Show Tax' do
    tax = Tax.create(name: 'ANTICIPO CREE (.40%)', reference: 'ANT_CREE', porcent: 0.40 , puc_account_id: PucAccount.last.id)
    visit '/admin/taxes'
    within("#tax_#{tax.id}") do
      click_link('View')
    end
    expect(page).to have_content tax.name
  end

  it 'Destroy Tax' do
    tax = Tax.create(name: 'ANTICIPO CREE (.40%)', reference: 'ANT_CREE', porcent: 0.40 , puc_account_id: PucAccount.last.id)
    visit '/admin/taxes'
    within("#tax_#{tax.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Tax was successfully destroyed'
  end

  it 'Test button Batch Actions' do
    tax = Tax.create(name: 'ANTICIPO CREE (.40%)', reference: 'ANT_CREE', porcent: 0.40 , puc_account_id: PucAccount.last.id)
    visit '/admin/taxes/'
    check("batch_action_item_#{tax.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 tax'
  end
end
