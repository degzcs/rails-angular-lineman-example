describe 'PopulationCenter', :type => :request do

  describe :v1 do
    context 'population_centers' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:population_center, 20)
      end

      context 'GET' do

        xit 'retrieves all population center registries' do
          get '/api/v1/population_centers', {} , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 21 #Plus 1 of the user created
        end

        context '/:id' do

          xit 'gets population center by id' do

            population_center = PopulationCenter.last

            expected_response = {
              id: population_center.id,
              name: population_center.name,
              population_center_code: population_center.code,
              latitude: population_center.latitude.to_s,
              longitude: population_center.longitude.to_s,
              population_center_type: population_center.type,
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