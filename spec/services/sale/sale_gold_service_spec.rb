require 'spec_helper'

describe Sale::SaleGoldService do

  subject(:service) { Sale::SaleGoldService.new }

  context 'a current user (trader) which is the legal_representative' do
    before :each do
      current_buyer = create(:user, :with_company, :with_trader_role).company.legal_representative
    	@current_seller = create(:user, :with_company, :with_trader_role).company.legal_representative
      # Add Alegra credentials to sync the buyer in his Alegra contacts
      @current_seller.update_column(:email, 'ejemploapi@dayrep.com')
      @current_seller.profile.setting.update_column(:alegra_token, '066b3ab09e72d4548e88')

      courier = create(:courier)
      purchases = create_list(:purchase, 2,
                              :with_origin_certificate_file,
                              :with_proof_of_purchase_file,
                              buyer: @current_seller)
      # TODO: change frontend implementation to avoid this.
      @selected_purchase_ids = purchases.map(&:id)
      @expected_response = {
        'courier_id' => courier.id,
        'buyer' => {
          'id' => current_buyer.id,
          'first_name' => current_buyer.profile.first_name,
          'last_name' => current_buyer.profile.last_name
        },
        'user_id' => @current_seller.id, # TODO: upgrade frontend
        'fine_grams' => 1.5
      }

      @gold_batch_hash = {
        'fine_grams' => 1.5,
        'grade' => 1,
        'mineral_type' => 'Oro'
      }

      @order_hash = {
        'courier_id' => courier.id,
        'buyer_id' => current_buyer.id,
        'price' => 180
      }
      APP_CONFIG[:ALEGRA_SYNC] = true
    end

    after :each do
      APP_CONFIG[:ALEGRA_SYNC] = false
    end

    it 'should create a pdf (call)' do
      VCR.use_cassette('alegra_create_trader_contact_in_sale_service') do
        response = service.call(
          order_hash: @order_hash,
          gold_batch_hash: @gold_batch_hash,
          current_user: @current_seller,
          selected_purchase_ids: @selected_purchase_ids
        )
        expect(response[:success]).to be true

        # test the state machine on transaction state
        sale = Order.last
        expect(sale.dispatched?).to eq(true)
        expect(sale.transaction_state).to eq('dispatched')

        # Alegra synchronization tests
        seller = sale.seller
        buyer = sale.buyer
        contact_info = sale.seller.contact_infos.find_by(contact: buyer)

        expect(contact_info.contact_alegra_id.present?).to eq true
        expect(contact_info.contact_alegra_sync).to eq true
      end
    end
  end
end
