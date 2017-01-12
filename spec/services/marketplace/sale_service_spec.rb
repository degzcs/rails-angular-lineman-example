require 'spec_helper'

describe Marketplace::SaleService do
  subject(:service) { Marketplace::SaleService.new }

  context 'a current user (trader) which is the legal_representative' do
    before :each do
      @current_seller = create(:user, :with_company, :with_trader_role).company.legal_representative
      @current_seller.update_column(:email, 'ejemploapi@dayrep2.com')
      @current_seller.profile.setting.update_column(:alegra_token, '066b3ab09e72d4548e88')

      purchases = create_list(:purchase, 2,
                              :with_origin_certificate_file,
                              :with_proof_of_purchase_file,
                              buyer: @current_seller)
      # TODO: change frontend implementation to avoid this.
      @selected_purchase_ids = purchases.map(&:id)

      @gold_batch_hash = {
        'fine_grams' => 1.5,
        'grade' => 1,
        'mineral_type' => 'Oro'
      }

      @order_hash = {
        'price' => 180
      }
    end

    it 'Should persist a sale and leave it in a published state' do
      response = service.call(
        order_hash: @order_hash,
        gold_batch_hash: @gold_batch_hash,
        current_user: @current_seller,
        selected_purchase_ids: @selected_purchase_ids
      )
      expect(response[:success]).to be true

      # test the state machine on transaction state
      sale = Order.first
      expect(sale.published?).to eq(true)
      expect(sale.transaction_state).to eq('published')
      expect(sale.buyer).to eq nil
    end
  end
end
