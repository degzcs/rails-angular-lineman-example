describe 'State', :type => :request do

  describe :v1 do
    context 'states' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:state, 20)
      end

      context 'GET' do

        it 'retrieves all state registries' do
          get '/api/v1/states', {} , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 20
        end
  
        context '/:id' do

          it 'gets state by id' do 

            state = State.last

            expected_response = {
              id: state.id,
              name: state.name,
              state_code: state.state_code
            }

            get "/api/v1/states/#{state.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end

        end

      end

    end

  end

end