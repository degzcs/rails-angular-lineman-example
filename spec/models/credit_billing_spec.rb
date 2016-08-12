# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  unit                :integer
#  per_unit_value      :float
#  payment_flag        :boolean          default(FALSE)
#  payment_date        :datetime
#  discount_percentage :float            default(0.0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  total_amount        :float            default(0.0), not null
#  discount            :float            default(0.0), not null
#

require 'spec_helper'

describe CreditBilling  do
  context "test factory" do
    let(:credit_billing) {build(:credit_billing)}
    it {expect(credit_billing.user_id).not_to be_nil }
    it {expect(credit_billing.unit).not_to be_nil }
    it {expect(credit_billing.per_unit_value).not_to be_nil}
    it {expect(credit_billing.payment_flag).not_to be_nil}
    it {expect(credit_billing.payment_date).not_to be_nil}
    it {expect(credit_billing.discount_percentage).not_to be_nil }
  end

  context "credit billing creation" do

    it "should not allow to create without user_id" do
      credit_billing = build(:credit_billing,user_id: nil)
      expect(credit_billing).to_not be_valid
    end

    it 'raise an error if the user is not a legal representative user' do
      user = create :user, :with_profile, :with_company, available_credits: 0, legal_representative: false
      legal_representative = user.company.legal_representative
      credit_billing = build(:credit_billing, user: user)
      expect { credit_billing.save! }.to raise_error.with_message(/Este usuario no esta autorizado para comprar creditos/)
    end

    it "should not allow to create without unit" do
      credit_billing = build(:credit_billing, unit: nil)
      expect(credit_billing).to_not be_valid
    end

    it "should not allow to create without per_unit_value" do
      credit_billing = build(:credit_billing, per_unit_value: nil)
      expect(credit_billing).to_not be_valid
    end

  end
end
