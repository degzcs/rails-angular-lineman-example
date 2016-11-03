require 'spec_helper'

describe Alegra::Traders::CreateInvoice do
  let(:seller) do
      create(:user,
        :with_profile,:with_company, :with_trader_role,
        first_name: 'Seller',
        last_name: 'Britho',
        alegra_id: 12, # NOTE: this alegra id is for Trazoro account
        legal_representative: true,
        email: 'ejemploapi@dayrep.com',
        setting: build(:user_setting, alegra_token: '066b3ab09e72d4548e88')
      )
    end
  let(:buyer) do
    create(:user,
      :with_profile,:with_company, :with_trader_role,
      first_name: 'Buyer',
      last_name: 'Britho',
      alegra_id: 13, # NOTE: this alegra id is for Trazoro account
      legal_representative: true
    )
  end
  let(:order) { create(:order, price: 2_000, seller: seller, buyer: buyer, transaction_state: 'dispatched') }

  before :each do
    # Add the current buyer to the seller contact infos table in order,
    # eventually, associated the buyer to Alegra with their alegra_id, which is diferent the alegra_id used in Users table.
    # the alegra_id in user is for Trazoro invoices in ALgra but the contact_alegra_id is for the trader Alegra account.
    seller.contact_infos.create(contact: buyer, contact_alegra_id: 1)
  end

  it 'should create an invoice in alegra' do
    VCR.use_cassette('alegra_create_traders_invoice') do
      service = Alegra::Traders::CreateInvoice.new
      service.call(order: order, payment_method: 'transfer', payment_date: '2016-11-03'.to_date )
      expect(service.response[:errors]).to eq([])
      expect(service.response[:success]).to eq(true)
      expect(order.invoiced).to eq true
      expect(order.alegra_id.present?).to eq true
      expect(order.payment_date.to_date).to eq '2016-11-03'.to_date
    end
  end

  it 'raise an error when the buyer is not synced yet' do
    # unsync user
    seller.contact_infos.find_by(contact: buyer).update_column(:contact_alegra_id, nil)
    service = Alegra::Traders::CreateInvoice.new
    service.call(order: order, payment_method: 'transfer', payment_date: '2016-11-03'.to_date )
    expect(service.response[:errors]).to eq(["The buyer has to be synchronized with Alegra (Trader alegra account not Trazoro's account) before to create an invoice"])
    expect(service.response[:success]).to eq(false)
    expect(order.alegra_id.present?).to eq false
    expect(order.payment_date).to eq nil
  end
end