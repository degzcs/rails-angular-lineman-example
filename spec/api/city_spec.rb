describe 'City', :type => :request do

  describe :v1 do
    context 'cities' do

      before :context do
        @user = create :user, :with_company, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'GET' do

        it 'retrieves all city registries' do
          get '/api/v1/cities', {} , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 565
        end

        context '/:id' do

          it 'gets city by id' do

            city = City.last

            expected_response = {
              id: city.id,
              name: city.name,
              city_code: city.code, # TODO: Upgrade the end-point and chenge this name
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
            city = City.last
            population_centers = create_list(:population_center, 10, city: city)

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