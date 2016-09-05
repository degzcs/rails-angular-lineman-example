# == Schema Information
#
# Table name: sold_batches
#
#  id             :integer          not null, primary key
#  grams_picked   :float
#  created_at     :datetime
#  updated_at     :datetime
#  gold_batch_id  :integer
#  transaction_id :integer
#

require 'spec_helper'

describe SoldBatch, type: :model do
  context "test factory" do
    let(:sold_batch) { build(:sold_batch) }
    it { expect(sold_batch.gold_batch).not_to be_nil }
    it { expect(sold_batch.sale).not_to be_nil }
  end

  context "test creation" do
    it "should build a new sale with valid data" do
      expect(build(:sold_batch)).to be_valid
    end
  end
end
