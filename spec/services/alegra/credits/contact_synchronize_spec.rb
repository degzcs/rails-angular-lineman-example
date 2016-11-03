require 'spec_helper'

describe Alegra::ContactSynchronize do
  let(:user) { create(:user, :with_profile,:with_company, :with_trader_role, first_name: 'Alan', last_name: 'Britho') }

  it 'should create a contact in alegra with the basic information' do
    VCR.use_cassette('alegra_create_contact') do
      contact_synchronize = Alegra::ContactSynchronize.new(user)
      contact_synchronize.call
      expect(contact_synchronize.response[:success]).to eq(true)
      expect(contact_synchronize.response[:errors]).to eq([])
      expect(user.reload.alegra_id.present?).to be true
      expect(user.alegra_sync).to eq true
    end
  end
end