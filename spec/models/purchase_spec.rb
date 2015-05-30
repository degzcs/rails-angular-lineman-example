# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  provider_id                 :integer
#  origin_certificate_sequence :string(255)
#  gold_batch_id               :integer
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#  seller_picture              :string(255)
#  code                        :text
#  trazoro                     :boolean          default(FALSE), not null
#  sale_id                     :integer
#

require 'spec_helper'

describe Purchase do


  context "test factory" do
    let(:purchase) { build :purchase }
    it {expect(purchase.user).not_to be_nil }
    it {expect(purchase.provider).not_to be_nil }
    it {expect(purchase.origin_certificate_sequence).not_to be_nil}
    it {expect(purchase.gold_batch).not_to be_nil}
    it {expect(purchase.origin_certificate_file).not_to be_nil}
    it {expect(purchase.price).not_to be_nil }
    it {expect(purchase.seller_picture).not_to be_nil}
    it {expect(purchase.trazoro).not_to be_nil}
    it {expect(purchase.provider_type).not_to be_nil}
  end
 
  context "purchase creation" do
    context "for a trazoro purchase (user - user purchase)" do
      let!(:user1) { create(:user) }
      let!(:user2) {create(:user)}
      let(:purchase) {create(:purchase, user: user1, provider: user2)}
      it "expect to have the correct user" do
        expect(purchase.user).to eq user1
      end
      it "expect to have the correct provider" do
        expect(purchase.provider).to eq user2
      end
    end
    context "for an external provider purchase" do
      let!(:user1) { create(:user) }
      let!(:external_user) {create(:external_user)}
      let(:purchase) {create(:purchase, user: user1, provider: external_user)}
      it "expect to have the correct user" do
        expect(purchase.user).to eq user1
      end
      it "expect to have the correct provider" do
        expect(purchase.provider).to eq external_user
      end
    end
  end
  
  context "test barcode generation" do
    let(:purchase) {build(:purchase)}
    before :each do
      purchase.save
      @code ="770#{purchase.user.id.to_s.rjust(5, '0') }#{ purchase.gold_batch_id.to_s.rjust(4, '0')}"
    end

    it "should generate a barcode when the purchase is  is created" do
      expect(purchase.reload.code).to eq @code
    end

    it "should generate a barcode when the purchase is  is created" do
      expect(purchase.reload.barcode_html).not_to be_nil
    end
  end

  context "test after creation callback methods" do
    context "create_inventory" do
      it 'creates a new inventory for the purchase with the same remaining_amount value of the gold_batch grams' do
        new_gold_batch = create(:gold_batch, fine_grams: 3.5,  )
        new_purchase = create(:purchase, gold_batch: new_gold_batch)
        expect(new_purchase.inventory.remaining_amount).to be 3.5 
      end
    end
  end

end
