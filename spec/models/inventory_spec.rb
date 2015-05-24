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

  context "instance methods" do
    context "discount_remainig_amount" do
      let(:purchase) {create(:purchase, gold_batch: create(:gold_batch, fine_grams: 300))}
      it "should discount an amount of grams from the remaining_amount" do
        purchase.inventory.discount_remainig_amount(130)
        expect(purchase.inventory.remaining_amount).to eq 170
      end
      it "should not allow to discount grams if the amount is less than 0" do
        expect{purchase.inventory.discount_remainig_amount(350)}.to raise_error(Inventory::EmptyInventory)
      end
    end
  end
end
