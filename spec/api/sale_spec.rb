# == Schema Information
#
# Table name: sales
#
#  id            :integer          not null, primary key
#  courier_id    :integer
#  client_id     :integer
#  user_id       :integer
#  gold_batch_id :integer
#  grams         :float
#  barcode       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

describe 'Sale', :type => :request do

  describe :v1 do
    context '#sales' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'POST' do
        it 'should create one complete sale' do
          client = create(:client)
          courier = create(:courier)

          expected_response = {
            "id"=>1,
            "courier_id"=>1,
            "client_id"=>client.id,
            "user_id"=>@user.id,
            "gold_batch_id"=>1,
            "grams"=>1.5,
          }

          new_gold_batch_values = {
            "id" => 1,
            "parent_batches" => "",
            "grams" => 1.5,
            "grade" => 1,
            "inventory_id" => 1,
          }

          new_values ={
            "id"=>1,
            "courier_id"=>courier.id,
            "client_id"=>client.id,
            "user_id"=>@user.id,
            "gold_batch_id" => new_gold_batch_values["id"],
            "grams" => new_gold_batch_values["grams"],
          }

          post '/api/v1/sales/', {gold_batch: new_gold_batch_values, sale: new_values},{"Authorization" => "Barer #{@token}"}
          expect(response.status).to eq 201
          expect(JSON.parse(response.body)).to include expected_response
        end
      end
=begin
      context "GET" do
        before(:all) do
          provider = create(:provider)
          create_list(:purchase, 20, user_id: @user.id, provider_id: provider.id)
        end
        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/purchases', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end
        context '/:id' do

          it 'gets purchase by id' do 

            purchase = Purchase.last

            expected_response = {
              id: purchase.id,
              price: purchase.price,
            }

            get "/api/v1/purchases/#{purchase.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end
      end
=end
    end
  end
end