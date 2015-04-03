describe 'City', :type => :request do

  describe :v1 do
    context 'cities' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:city, 20)
      end

      context 'GET' do

        it 'retrieves all city registries' do
          get '/api/v1/cities', {} , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 20
        end
  
        context '/:id' do

          it 'gets city by id' do 

            city = City.last

            expected_response = {
              id: city.id,
              name: city.name,
              city_code: city.city_code,
              state_id: city.state_id,
              state_code: city.state_code,
            }

            get "/api/v1/cities/#{city.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end

        end

        context '/:id/population_centers' do

          it 'gets all population centers from a city' do 
            city = create(:city)
            population_centers = create_list(:population_center, 10, city_id: city.id, city_code: city.city_code)

            expected_response = population_centers

            get "/api/v1/cities/#{city.id}/population_centers",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to be 10
          end

        end

      end

    end

  end

end