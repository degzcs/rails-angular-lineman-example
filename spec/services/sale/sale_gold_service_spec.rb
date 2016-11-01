require 'spec_helper'

describe Sale::SaleGoldService do
  
  subject(:service) { Sale::SaleGoldService.new }

  context 'a current user (trader)' do
    before :each do
      @current_buyer = create(:user, :with_company, :with_trader_role).company.legal_representative
    	current_seller = @current_buyer.company.legal_representative
      courier = create(:courier)
      purchases = create_list(:purchase, 2,
                              :with_origin_certificate_file,
                              :with_proof_of_purchase_file,
                              buyer: current_seller)
      # TODO: change frontend implementation to avoid this.
      @selected_purchase_ids = purchases.map(&:id)
      @expected_response = {
        'courier_id' => courier.id,
        'buyer' => {
          'id' => @current_buyer.id,
          'first_name' => @current_buyer.profile.first_name,
          'last_name' => @current_buyer.profile.last_name
        },
        'user_id' => current_seller.id, # TODO: upgrade frontend
        'fine_grams' => 1.5
      }

      @gold_batch_hash = {
        'fine_grams' => 1.5,
        'grade' => 1
      }

      @order_hash = {
        'courier_id' => courier.id,
        'buyer_id' => @current_buyer.id,
        'price' => 180
      }
    end

    it 'should create a pdf (call)' do
        response = service.call(
        order_hash: @order_hash,
        gold_batch_hash: @gold_batch_hash,
        current_user: @current_buyer, # TODO: worker
        selected_purchase_ids: @selected_purchase_ids
      )
      expect(response[:success]).to be true

      # test the state machine on transaction state
      sale = Order.last
      
      expect(sale.dispatched?).to eq(true)
      expect(sale.transaction_state).to eq('dispatched')
    end
  end
end
