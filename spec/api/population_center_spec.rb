describe 'PopulationCenter', :type => :request do

  describe :v1 do
    context 'population_centers' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:population_center, 20)
      end

      context 'GET' do

        it 'retrieves all population center registries' do
          get '/api/v1/population_centers', {} , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 20
        end
  
        context '/:id' do

          it 'gets population center by id' do 

            population_center = PopulationCenter.last

            expected_response = {
              id: population_center.id,
              name: population_center.name,
              population_center_code: population_center.population_center_code,
              latitude: population_center.latitude.to_s,
              longitude: population_center.longitude.to_s,
              population_center_type: population_center.population_center_type,
              city_id: population_center.city_id,
              city_code: population_center.city_code,
            }

            get "/api/v1/population_centers/#{population_center.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end

        end

      end

    end

  end

end