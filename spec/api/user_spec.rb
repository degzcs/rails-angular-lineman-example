describe 'Auth', :type => :request do

  describe :v1 do
    context '#me' do

      before :context do
        @user = FactoryGirl.create :user, :with_personal_rucom
        @token = @user.create_token
      end

      context 'GET' do
        it 'show the user info, this user dont have company' do
          expected_response = {
           "id"=> @user.id,
           "first_name" => @user.first_name,
           "last_name" => @user.last_name,
           "nit" => nil, # NOTE: This field is not mandatory because not all barequeros have this document, they should but they dont have it.
           "email" => @user.email,
           "document_number" => @user.document_number,
           #"access_token"=> @token,
           "available_credits" => @user.available_credits,
           "phone_number" => @user.phone_number,
           "address" => @user.address,
           "office" => nil,
           "company_name" => nil,
           "company" => nil,
           "photo_file" => {
             "url" => "/uploads/photos/user/photo_file/5/photo_file.png"
            },
          }

          get '/api/v1/users/me', {},{ "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expected_response.each do |key, value|
            expect(JSON.parse(response.body)[key]).to eq value
          end
        end

      end
      context 'UPDATE' do
        it 'should update the current user info' do
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