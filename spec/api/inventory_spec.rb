
describe 'Inventory', :type => :request do

  describe :v1 do
    context '#inventories' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'PUT' do
        it 'should update an inventory after a sale is created' do
          gold_batch = create(:gold_batch, grams: 100)
          purchase = create(:purchase, gold_batch: gold_batch)
          ##
          sale = create(:sale)
          amount_picked = 20
          inventory = purchase.inventory
          put "/api/v1/inventories/#{inventory.id}", {sale_id: sale.id,amount_picked: amount_picked}, { "Authorization" => "Barer #{@token}" }
          inventory.reload
          expect(inventory.remaining_amount).to eq 80
          expect(response.status).to eq 200
        end
      end
    end
  end
end