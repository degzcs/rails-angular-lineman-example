# == Schema Information
#
# Table name: sales
#
#  id           :integer          not null, primary key
#  courier_id   :integer
#  code         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  price        :float
#  trazoro      :boolean          default(FALSE), not null
#  inventory_id :integer
#  buyer_id     :integer
#

require 'spec_helper'

describe 'Sale' do
  context 'test factory' do
    let(:sale) { build(:sale) }
    it { expect(sale.courier).not_to be_nil }
    it { expect(sale.seller).not_to be_nil }
    it { expect(sale.buyer).not_to be_nil  }
    it { expect(sale.gold_batch).not_to be_nil }
    it { expect(sale.code).not_to be_nil }
    it { expect(sale.price).not_to be_nil }
  end

  context 'sale creation' do
    it 'should create a new sale with valid data' do
      expect(build(:sale)).to be_valid
    end

    context 'for a trazoro sale (user - user sale)' do
      let!(:seller) { create(:user, :with_company) }
      let!(:buyer) { create(:user, :with_company) }
      let(:sale) { create(:sale, seller: seller, buyer: buyer, trazoro: true) }
      it 'expect to have the correct user' do
        expect(sale.trazoro).to be true
        expect(sale.seller).to eq seller
      end
      it 'expect to have the correct buyer' do
        expect(sale.trazoro).to be true
        expect(sale.buyer).to eq buyer
      end
    end

    context 'for an authotize_provider buyer purchase' do
      let!(:seller) { create(:user, :with_company) }
      let!(:buyer) { create(:user, :with_personal_rucom, :with_authorized_provider_role) }
      let(:sale) { create(:sale, seller: seller, buyer: buyer) }
      it 'expect to have the correct user' do
        expect(sale.trazoro).to be false
        expect(sale.seller).to eq seller
      end
      it 'expect to have the correct buyer' do
        expect(sale.trazoro).to be false
        expect(sale.buyer).to eq buyer
      end
    end
  end

  context 'documentation' do
    it 'should create a sale with proof of sale file' do
      sale = create :sale, :with_proof_of_sale_file
      expect(sale.proof_of_sale.file.path).to match(/compendio_trazoro.pdf/)
    end

    it 'should create a sale with purchase files collection file' do
      sale = create :sale, :with_purchase_files_collection_file
      expect(sale.purchase_files_collection.file.path).to match(/compendio_trazoro.pdf/)
    end
  end

  context 'test barcode generations' do
    it 'should generate a code when the sale is created' do
      new_sale = create(:sale)
      expect(new_sale.code).not_to be_nil
    end
  end
end
