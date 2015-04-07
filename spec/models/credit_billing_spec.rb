# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  unit                :string(255)
#  per_unit_value      :float
#  iva_value           :float
#  discount            :float
#  total_amount        :float
#  payment_flag        :boolean
#  payment_date        :datetime
#  discount_percentage :float
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe CreditBilling  do
  context "test factory" do
    let(:credit_billing) {build(:credit_billing)}
    it {expect(credit_billing.user_id).not_to be_nil }
    it {expect(credit_billing.unit).not_to be_nil }
    it {expect(credit_billing.per_unit_value).not_to be_nil}
    it {expect(credit_billing.iva_value).not_to be_nil}
    it {expect(credit_billing.discount).not_to be_nil}
    it {expect(credit_billing.total_amount).not_to be_nil}
    it {expect(credit_billing.payment_flag).not_to be_nil}
    it {expect(credit_billing.payment_date).not_to be_nil}
    it {expect(credit_billing.discount_percentage).not_to be_nil }
  end

  context "credit billing creation" do
    
    it "should not allow to create without user_id" do
      credit_billing = build(:credit_billing,user_id: nil)
      expect(credit_billing).to_not be_valid
    end

    it "should not allow to create without unit" do
      credit_billing = build(:credit_billing,unit: nil)
      expect(credit_billing).to_not be_valid
    end

    it "should not allow to create without per_unit_value" do
      credit_billing = build(:credit_billing,per_unit_value: nil)
      expect(credit_billing).to_not be_valid
    end

    it "should not allow to create without iva_value" do
      credit_billing = build(:credit_billing,iva_value: nil)
      expect(credit_billing).to_not be_valid
    end

    it "should not allow to create without total_amount" do
      credit_billing = build(:credit_billing,total_amount: nil)
      expect(credit_billing).to_not be_valid
    end

    it "should not allow to create without payment_flag" do
      credit_billing = build(:credit_billing,payment_flag: nil)
      expect(credit_billing).to_not be_valid
    end

  end


end
