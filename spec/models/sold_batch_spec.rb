# == Schema Information
#
# Table name: sold_batches
#
#  id           :integer          not null, primary key
#  purchase_id  :integer
#  grams_picked :float
#  sale_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe SoldBatch, type: :model do
  context "test factory" do
    let(:sold_batch) {build(:sold_batch)}
    it {expect(sold_batch.purchase_id).not_to be_nil }
    it {expect(sold_batch.grams_picked).not_to be_nil }
    it {expect(sold_batch.sale_id).not_to be_nil}
  end
  context "test creation" do
    it "should create a new sale with valid data" do
      expect(build(:sold_batch)).to be_valid
    end

    it "should not allow to create a sold_batch without a purchase id " do
      expect(build(:sold_batch, purchase_id: nil)).not_to be_valid
    end
    it "should not allow to create a sold_batch without grams picked" do
      expect(build(:sold_batch, grams_picked: nil)).not_to be_valid
    end
  end
end
