describe 'Auth', :type => :request do

  describe :v1 do
    context '#purchases' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'POST' do
        it 'should create one purchase with one orgin cetificate file' do
          expected_response = {
           "id"=>1,
           "user_id"=>1,
           "provider_id"=>1,
           "gold_batch_id" => 1,
           "amount" => 1.5,
           "origin_certificate_file" => "image.png",
           # "origin_certificate_sequence"=>"???",
          }

          new_values ={
           "id"=>1,
           "user_id"=>1,
           "provider_id"=>1,
           "gold_batch_id" => 1,
           "amount" => 1.5,
           "origin_certificate_file" => "image.png",
          }
          post '/api/v1/purchases/', {purchase: new_values},{ "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to include expected_response
        end
      end
    end
  end
end