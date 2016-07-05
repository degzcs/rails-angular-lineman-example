require 'spec_helper'

describe CreditBilling::Acceptance do

  let(:service){ CreditBilling::Acceptance.new }

  context 'buy some credits' do

    it 'should buy credits for single user without company' do
      user = create :user, :with_profile, :with_personal_rucom, nit_number: nil, available_credits: 7.0
      credit_billing = create :credit_billing, user: user, unit: 10.0

      new_credit_billing_values = {
        payment_flag: true,
        payment_date: Time.now,
        discount_percentage: 0
      }

      response = service.call(
        credit_billing: credit_billing,
        new_credit_billing_values: new_credit_billing_values)
      expect(response[:success]).to eq true
      expect(user.reload.available_credits).to eq 17.0
    end

    it 'should buy credits for the legal representative' do
      user = FactoryGirl.create :user, :with_profile, :with_company, available_credits: 0
      legal_representative = user.company.legal_representative
      legal_representative.profile.update_column :available_credits, 5.0

      credit_billing = create :credit_billing, user: legal_representative, unit: 10.0

      new_credit_billing_values = {
        payment_flag: true,
        payment_date: Time.now,
        discount_percentage: 0
      }

      response = service.call(
        credit_billing: credit_billing,
        new_credit_billing_values: new_credit_billing_values)
      expect(response[:success]).to eq true
      expect(user.reload.available_credits).to eq 0.0
      expect(legal_representative.reload.available_credits).to eq 15.0
    end
  end
end