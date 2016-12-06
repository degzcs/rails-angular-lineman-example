require 'spec_helper'

describe Alegra::Traders::ContactSynchronize do
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

  it 'should create a contact in alegra with the basic information' do
    VCR.use_cassette('alegra_create_trader_contact') do
      contact_synchronize = Alegra::Traders::ContactSynchronize.new(seller: seller, buyer: buyer)
      response = contact_synchronize.call
      expect(response[:errors]).to eq([])
      expect(response[:success]).to eq(true)
      contact_info = seller.contact_infos.find_by(contact: buyer)
      expect(contact_info.contact_alegra_id.present?).to be true
      expect(contact_info.contact_alegra_sync).to eq true
    end
  end

  it 'should to update a user in alegra' do
    VCR.use_cassette('alegra_create_trader_contact') do
      seller.contact_infos.new(contact_alegra_id: 1, contact_alegra_sync: true, contact: buyer).save!
      contact_synchronize = Alegra::Traders::ContactSynchronize.new(seller: seller, buyer: buyer)
      response = contact_synchronize.call
      expect(response[:errors]).to eq([])
      expect(response[:success]).to eq(true)
      contact_info = seller.contact_infos.find_by(contact: buyer)
      expect(contact_info.contact_alegra_id.present?).to be true
      expect(contact_info.contact_alegra_sync).to eq true
    end
  end
end