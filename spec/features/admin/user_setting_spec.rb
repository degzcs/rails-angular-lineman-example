require 'spec_helper'

describe 'all test the user_settings view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
    company = create(:company )
    legal_representative = company.legal_representative
    user_setting = legal_representative.setting
  end

  after :each do
    user_setting = UserSetting.last
    user_setting.destroy! if user_setting.present?
  end

  xit 'New TransactionMovement' do
    visit '/admin/transaction_movements/new'
    expected_response = {
      last_transaction_sequence: 0,
      regime_type: { value: 'RC', select_name: UserSetting::REGIME_TYPES[:RC] },
      activity_code: { value: 'movements', select_name: UserSetting::CODE_ACTIVITIES['11'] },
      scope_of_operation: { value: 'NAL', select_name: UserSetting::SCOPE_OPERATIONS[:NAL] },      
      organization_type: 'SAS',
      self_holding_agent: { value: 'f', select_name: UserSetting::SELF_HOLDING_AGENTS['f'] }    
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

  xit 'Edit TransactionMovement' do
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

  xit 'Show TransactionMovement' do
    transaction_movement = TransactionMovement.create(puc_account_id: PucAccount.last.id , type: 'sale', block_name: 'movements', afectation: 'D')
    visit '/admin/transaction_movements'
    within("#transaction_movement_#{transaction_movement.id}") do
      click_link('View')
    end
    expect(page).to have_content transaction_movement.id
  end

  xit 'Destroy TransactionMovement' do
    transaction_movement = TransactionMovement.create(puc_account_id: PucAccount.last.id , type: 'sale', block_name: 'movements', afectation: 'D')
    visit '/admin/transaction_movements'
    within("#transaction_movement_#{transaction_movement.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Transaction movement was successfully destroyed'
  end

  xit 'Test button Batch Actions' do
    transaction_movement = TransactionMovement.create(puc_account_id: PucAccount.last.id , type: 'sale', block_name: 'movements', afectation: 'D')
    visit '/admin/transaction_movements/'
    check("batch_action_item_#{transaction_movement.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 transaction movement'
  end
end
