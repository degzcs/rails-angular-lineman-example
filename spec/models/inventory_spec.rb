# == Schema Information
#
# Table name: inventories
#
#  id               :integer          not null, primary key
#  purchase_id      :integer
#  remaining_amount :float            not null
#  status           :boolean          default(TRUE), not null
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

RSpec.describe Inventory, type: :model do
  context "test factory" do
    let(:inventory) {build(:inventory)}
    it {expect(inventory.purchase_id).not_to be_nil }
    it {expect(inventory.remaining_amount).not_to be_nil}
    it {expect(inventory.status).not_to be_nil}
  end

  context "test creation" do

    it "should create a new inventory with valid data" do
      expect(build(:inventory)).to be_valid
    end

    it "should not allow to create a inventory without a purchase id" do
      expect(build(:inventory, purchase_id: nil)).not_to be_valid
    end

    it "should not allow to create a provider without remaining_amount" do
      inventory = build(:inventory, remaining_amount: nil)
      expect(inventory).not_to be_valid
    end
  end

  context "test after creation callback methods" do
    context "create_inventory" do
      it 'creates a new inventory for the purchase with the same remaining_amount value of the gold_batch grams' do
        new_gold_batch = create(:gold_batch, grams: 3.5,  )
        new_purchase = create(:purchase, gold_batch_id: new_gold_batch.id)
        expect(new_purchase.inventory.remaining_amount).to be 3.5 
      end
    end

  end
  
end
