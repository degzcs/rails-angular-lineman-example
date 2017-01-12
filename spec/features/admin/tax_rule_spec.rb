require 'spec_helper'

describe 'all test the tax_rules view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
    puc_account = PucAccount.create(code: '135595', name: 'ANTICIPO CREE (.40%)')
    tax = Tax.create(name: 'ANTICIPO CREE (.40%)', reference: 'ANT_CREE', porcent: 0.40 , puc_account_id: puc_account.id)
  end

  after :each do
    tax_rule = TaxRule.last
    tax_rule.destroy! if tax_rule.present?
  end

  it 'New Tax' do
    visit '/admin/tax_rules/new'
    expected_response = {
      tax: {id: Tax.taxes_for_select.last[1], select_name: Tax.taxes_for_select.last[0]},
      seller_regime: { value: 'RC', select_name: UserSetting::REGIME_TYPES[:RC] },
      buyer_regime: { value: 'GC', select_name: UserSetting::REGIME_TYPES[:GC] }
    }
   
    select(expected_response[:seller_regime][:select_name], from: 'tax_rule_seller_regime')
    select(expected_response[:buyer_regime][:select_name], from: 'tax_rule_buyer_regime')
    select(expected_response[:tax][:select_name], from: 'tax_rule_tax_id')
    click_button('Create Tax rule')
    last_tax_rule = TaxRule.order(:created_at).last.as_json.with_indifferent_access

    expect(last_tax_rule[:seller_regime]).to eq expected_response[:seller_regime][:value]
    expect(last_tax_rule[:buyer_regime]).to eq expected_response[:buyer_regime][:value]
    expect(last_tax_rule[:tax_id]).to eq expected_response[:tax][:id]
    expect(page).to have_content 'Tax rule was successfully created.'
  end

  it 'Edit TaxRule' do
    expected_response = {
      seller_regime: { value: 'RS', select_name: UserSetting::REGIME_TYPES[:RS] },
    }
    tax_rule = TaxRule.create(tax_id: Tax.last.id , seller_regime: 'RC', buyer_regime: 'GC')
    visit '/admin/tax_rules'
    within("#tax_rule_#{tax_rule.id}") do
      click_link('Edit')
    end
    # update admin_user with new info
    select(expected_response[:seller_regime][:select_name], from: 'tax_rule_seller_regime')
    click_button('Update Tax')
    expect(tax_rule.reload.seller_regime).to eq expected_response[:seller_regime][:value]
  end

  it 'Show TaxRule' do
    tax_rule = TaxRule.create(tax_id: Tax.last.id , seller_regime: 'RC', buyer_regime: 'GC')
    visit '/admin/tax_rules'
    within("#tax_rule_#{tax_rule.id}") do
      click_link('View')
    end
    expect(page).to have_content tax_rule.id
  end

  it 'Destroy TaxRule' do
    tax_rule = TaxRule.create(tax_id: Tax.last.id , seller_regime: 'RC', buyer_regime: 'GC')
    visit '/admin/tax_rules'
    within("#tax_rule_#{tax_rule.id}") do
      click_link('Delete')
    end
    expect(page).to have_content 'Tax rule was successfully destroyed'
  end

  it 'Test button Batch Actions' do
    tax_rule = TaxRule.create(tax_id: Tax.last.id , seller_regime: 'RC', buyer_regime: 'GC')
    visit '/admin/tax_rules/'
    check("batch_action_item_#{tax_rule.id}")
    click_on('Batch Actions')
    click_on('Delete Selected')
    click_on('OK')
    expect(page).to have_content 'Successfully destroyed 1 tax rule'
  end
end
