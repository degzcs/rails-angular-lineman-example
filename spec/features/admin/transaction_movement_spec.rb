require 'spec_helper'

describe 'all test the transaction_movements view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
    puc_account = PucAccount.create(code: '135595', name: 'ANTICIPO CREE (.40%)')
  end

  after :each do
    transaction_movement = TransactionMovement.last
    transaction_movement.destroy! if transaction_movement.present?
  end

  it 'New TransactionMovement' do
    visit '/admin/transaction_movements/new'
    expected_response = {
      puc_account: {id: PucAccount.accounts_for_select.last[1], select_name: PucAccount.accounts_for_select.last[0]},
      type: { value: 'sale', select_name: TransactionMovement::TYPES[:sale] },
      block_name: { value: 'movements', select_name: TransactionMovement::BLOCK_NAMES[:movements] },
      afectation: { value: 'D', select_name: TransactionMovement::AFECTATIONS[:D] },      
    }
    select(expected_response[:puc_account][:select_name], from: 'transaction_movement_puc_account_id')
    select(expected_response[:type][:select_name], from: 'transaction_movement_type')
    select(expected_response[:block_name][:select_name], from: 'transaction_movement_block_name')
    select(expected_response[:afectation][:select_name], from: 'transaction_movement_afectation')
    click_button('Create Transaction movement')
    last_tax_rule = TransactionMovement.order(:created_at).last.as_json.with_indifferent_access

    expect(last_tax_rule[:puc_account_id]).to eq expected_response[:puc_account][:id]
    expect(last_tax_rule[:type]).to eq expected_response[:type][:value]
    expect(last_tax_rule[:block_name]).to eq expected_response[:block_name][:value]
    expect(last_tax_rule[:afectation]).to eq expected_response[:afectation][:value]
    expect(page).to have_content 'Transaction movement was successfully created.'
  end

  it 'Edit TransactionMovement' do
    expected_response = {
      afectation: { value: 'C', select_name: TransactionMovement::AFECTATIONS[:C] }
    }
    transaction_movement = TransactionMovement.create(puc_account_id: PucAccount.last.id , type: 'sale', block_name: 'movements', afectation: 'D')
    visit '/admin/transaction_movements'
    within("#transaction_movement_#{transaction_movement.id}") do
      click_link('Edit')
    end
    # update admin_user with new info
    select(expected_response[:afectation][:select_name], from: 'transaction_movement_afectation')
    click_button('Update Transaction movement')
    expect(transaction_movement.reload.afectation).to eq expected_response[:afectation][:value]
  end

  it 'Show TransactionMovement' do
    transaction_movement = TransactionMovement.create(puc_account_id: PucAccount.last.id , type: 'sale', block_name: 'movements', afectation: 'D')
    visit '/admin/transaction_movements'
    within("#transaction_movement_#{transaction_movement.id}") do
      click_link('View')
    end
    expect(page).to have_content transaction_movement.id
  end

  it 'Destroy TransactionMovement' do
    transaction_movement = TransactionMovement.create(puc_account_id: PucAccount.last.id , type: 'sale', block_name: 'movements', afectation: 'D')
    visit '/admin/transaction_movements'
    within("#transaction_movement_#{transaction_movement.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Transaction movement was successfully destroyed'
  end

  it 'Test button Batch Actions' do
    transaction_movement = TransactionMovement.create(puc_account_id: PucAccount.last.id , type: 'sale', block_name: 'movements', afectation: 'D')
    visit '/admin/transaction_movements/'
    check("batch_action_item_#{transaction_movement.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 transaction movement'
  end
end
