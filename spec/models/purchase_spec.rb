# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  origin_certificate_sequence :string(255)
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#  seller_picture              :string(255)
#  code                        :text
#  trazoro                     :boolean          default(FALSE), not null
#  seller_id                   :integer
#  inventory_id                :integer
#

require 'spec_helper'

describe 'Purchase' do
  context 'test factory' do
    let(:purchase) { create :purchase }
    it 'has a valid factory' do
      expect(purchase).to be_valid
    end
    it { expect(purchase.seller).not_to be_nil }
    it { expect(purchase.buyer).not_to be_nil }
    it { expect(purchase.code).not_to be_nil }
    it { expect(purchase.gold_batch).not_to be_nil }
    it { expect(purchase.price).not_to be_nil }
    it { expect(purchase.seller_picture).not_to be_nil }
    it { expect(purchase.trazoro).not_to be_nil }
    it { expect(purchase.documents).not_to be_nil }
    it { expect(purchase.performer).not_to be_nil }
  end

  context 'purchase creation' do
    context 'for a trazoro purchase (user - user purchase)' do
      let!(:buyer) { create(:user, :with_company) }
      let!(:seller) { create(:user, :with_company) }
      let(:purchase) { create(:purchase, buyer: buyer, seller: seller, trazoro: true) }
      it 'expect to have the correct user' do
        expect(purchase.trazoro).to be true
        expect(purchase.buyer).to eq buyer
      end
      it 'expect to have the correct seller' do
        expect(purchase.trazoro).to be true
        expect(purchase.seller).to eq seller
      end
    end
    context 'for an authorized provider seller' do
      let!(:buyer) { create(:user, :with_company) }
      let!(:seller) { create(:user, :with_personal_rucom, :with_authorized_provider_role) }
      let(:purchase) { create(:purchase, buyer: buyer, seller: seller) }
      it 'expect to have the correct user' do
        expect(purchase.trazoro).to be false
        expect(purchase.buyer).to eq buyer
      end
      it 'expect to have the correct seller' do
        expect(purchase.trazoro).to be false
        expect(purchase.seller).to eq seller
      end
    end
  end

  context 'test barcode generation' do
    let(:purchase) { build(:purchase) }
    before :each do
      purchase.save
      @code = "770#{purchase.seller.id.to_s.rjust(5, '0')}#{purchase.gold_batch.id.to_s.rjust(4, '0')}"
    end

    it 'should generate a barcode when the purchase is  is created' do
      expect(purchase.reload.code).to eq @code
    end

    it 'should generate a barcode when the purchase is  is created' do
      expect(purchase.reload.barcode_html).not_to be_nil
    end
  end

  context 'Scopes' do
    it 'should check that the remaining_amount for a specific buyer' do
      new_gold_batch = create(:gold_batch, fine_grams: 3.5)
      new_purchase = create(:purchase, gold_batch: new_gold_batch)
      buyer = new_purchase.buyer
      expect(Order.remaining_amount_for(buyer)).to be 3.5
    end
  end
end
