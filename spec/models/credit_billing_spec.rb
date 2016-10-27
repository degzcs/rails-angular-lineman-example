# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  payment_date        :datetime
#  discount_percentage :float            default(0.0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  total_amount        :float            default(0.0), not null
#  discount            :float            default(0.0), not null
#  paid                :boolean          default(FALSE)
#  quantity            :float
#  unit_price          :float
#

require 'spec_helper'

describe CreditBilling  do
  context "test factory" do
    it 'should be valid' do
      credit_billing = build(:credit_billing)
      expect(credit_billing).to be_valid
    end
  end

  context "credit billing creation" do
    it "should not allow to create without user_id" do
      credit_billing = build(:credit_billing, user_id: nil)
      expect(credit_billing).to_not be_valid
    end

    it 'raise an error if the user is not a legal representative user' do
      user = create :user, :with_profile, :with_company, available_credits: 0, legal_representative: false
      legal_representative = user.company.legal_representative
      credit_billing = build(:credit_billing, user: user)
      expect { credit_billing.save! }.to raise_error.with_message(/Este usuario no esta autorizado para comprar creditos/)
    end

    it "should not allow to create without quantity" do
      credit_billing = build(:credit_billing, quantity: nil)
      expect(credit_billing).to_not be_valid
    end

    it "should not allow to create without unit_price" do
      credit_billing = build(:credit_billing, unit_price: nil)
      expect(credit_billing).to_not be_valid
    end
  end
end
