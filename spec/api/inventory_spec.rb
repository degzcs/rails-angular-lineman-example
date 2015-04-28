
describe 'Invenotry', :type => :request do

  describe :v1 do
    context '#inventories' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'PUT' do
        it 'should update an inventory' do
          gold_batch = create(:gold_batch, grams: 100)
          purchase = create(:purchase, gold_batch: gold_batch)
          inventory = purchase.inventory
          new_inventory_remaining_amount = 50
          new_values = {
            remaining_amount: new_inventory_remaining_amount
          }
          put "/api/v1/inventories/#{inventory.id}", {inventory: new_values}, { "Authorization" => "Barer #{@token}" }
          inventory.reload
          expect(inventory.remaining_amount).to eq 50
          expect(response.status).to eq 200
        end
      end
    end
  end
end