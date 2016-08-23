describe 'State', :type => :request do

  describe :v1 do
    context 'states' do

      before :context do
        @user = create :user, :with_company, password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'GET' do

        it 'retrieves all state registries' do
          get '/api/v1/states', {} , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 33
        end

        context '/:id' do

          it 'gets state by id' do

            state = State.last

            expected_response = {
              id: state.id,
              name: state.name,
              state_code: state.code
            }

            get "/api/v1/states/#{state.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end

        end

        context '/:id/cities' do

          it 'gets all cities from a state' do
            state = State.find_by(name: 'ANTIOQUIA')
            cities = state.cities

            expected_response = cities

            get "/api/v1/states/#{state.id}/cities",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to be 125
          end
        end
      end
    end
  end
end