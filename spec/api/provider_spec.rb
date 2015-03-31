describe 'Provider', :type => :request do

  describe :v1 do
    context 'providers' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:provider, 20)
      end

      context 'GET' do

        it 'verifies that response has the elements number specified in per_page param' do
          
          per_page = 5
          
          get '/api/v1/providers', {per_page: per_page},{ "Authorization" => "Barer #{@token}" }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end
=begin
        context '/:id' do

          it 'gets session by id' do

            session = EmoSession.last

            expected_response = {
              id: session.id.to_s,
              start_at: session.start_at,
              user_id: session.user_id
            }

            get "/api/v1/sessions/#{session.id.to_s}", braim_token: @credentials['access_token']
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end

        end
=end
      end
=begin
      context 'POST' do
        it 'returns a representation of new session and code 201' do
          new_session = @user.emo_sessions.build start_at: Time.now

          token = "braim_token=#{@credentials['access_token']}"
          data = "session[user_id]=#{new_session.user_id}"

          expected_response = {
            user_id: new_session.user_id.to_s
          }

          post '/api/v1/sessions', "#{token}&#{data}"

          expect(response.status).to eq 201
          expect(JSON.parse(response.body).except('id','start_at')).to match(expected_response.stringify_keys)
        end
      end
=end
    end

  end

end