require 'spec_helper'

describe Alegra::Credits::CreateInvoice do
  let(:user) { create(:user, :with_profile,:with_company, :with_trader_role, first_name: 'Alan', last_name: 'Britho', alegra_id: 1) }
  let(:credit_billing) { create(:credit_billing, quantity: 2_000, unit_price: 120000, discount_percentage: 10) }

  it 'should create an invoice in alegra' do
    VCR.use_cassette('alegra_create_credits_invoice') do
      service = Alegra::Credits::CreateInvoice.new
      service.call(date: '2016-10-27'.to_date, trader_user: user, payment_method: 'cash', credit_billing: credit_billing )
      expect(service.response[:success]).to eq(true)
      expect(service.response[:errors]).to eq([])
      expect(credit_billing.reload.alegra_id.present?).to be true
      expect(credit_billing.invoiced).to eq true
    end
  end
end