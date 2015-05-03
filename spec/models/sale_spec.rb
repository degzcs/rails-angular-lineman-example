# == Schema Information
#
# Table name: sales
#
#  id                      :integer          not null, primary key
#  courier_id              :integer
#  client_id               :integer
#  user_id                 :integer
#  gold_batch_id           :integer
#  code                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  origin_certificate_file :string(255)
#  price                   :float
#

require 'spec_helper'

describe Sale do
  context "test factory" do
    let(:sale) {build(:sale)}
    it {expect(sale.courier_id).not_to be_nil }
    it {expect(sale.client_id).not_to be_nil }
    it {expect(sale.user_id).not_to be_nil}
    it {expect(sale.gold_batch_id).not_to be_nil}
    it {expect(sale.code).not_to be_nil}
  end
  context "test creation" do
    it "should create a new sale with valid data" do
      expect(build(:sale)).to be_valid
    end

    it "should not allow to create a sale without a courier id" do
      expect(build(:sale, courier_id: nil)).not_to be_valid
    end

    it "should not allow to create a sale without client id" do
      expect(build(:sale, client_id: nil)).not_to be_valid
    end
    #it "should not allow to create a sale without barcode" do
      #expect(build(:sale, grams: nil)).not_to be_valid
    #end
  end

  context "test barcode generations" do
    it "should generate a code when the sale is created" do
      new_sale = create(:sale)
      expect(new_sale.code).not_to be_nil
    end
  end
end
