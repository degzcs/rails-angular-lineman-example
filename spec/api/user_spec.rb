describe 'Auth', :type => :request do

  describe :v1 do
    context '#me' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'GET' do
        it 'show the user info' do
          expected_response = {
            "id"=>1,
           "first_name"=>@user.first_name,
           "last_name"=>@user.last_name,
           "email"=>"elcho.esquillas@fake.com",
           "document_number"=>@user.document_number,
           "access_token"=> @token,
           "available_credits"=> @user.available_credits,
           "phone_number"=>@user.phone_number,
           "address"=>@user.address,
           
          }

          get '/api/v1/users/me', {},{ "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to include expected_response
        end

      end
      context 'UPDATE' do
        it 'should update user info' do 
          expected_response = {
           "id"=>1,
           "first_name"=>"Armando",
           "last_name"=>"Casas",
           "email"=>"armando.casas@fake.com",
           "available_credits"=> @user.available_credits
          }

          new_values ={
           "first_name"=>"Armando",
           "last_name"=>"Casas",
           "email"=>"armando.casas@fake.com",
          }
          put '/api/v1/users/', {user: new_values},{ "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to include expected_response
        end
      end
    end
  end
end