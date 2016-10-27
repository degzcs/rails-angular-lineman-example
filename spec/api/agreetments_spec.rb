describe 'Agreetments', type: :request do
  describe :v1 do
    context 'agreetments' do
      before :context do
        @user = create(
          :user,
          :with_trader_role,
          :with_company,
          email: "testing_#{User.count + 100}@fake.com",
          password: 'super_password',
          password_confirmation: 'super_password'
        )
        @token = @user.create_token
      end

      context 'GET' do
        context '/fixed_sale' do
          context 'When the current user role is a Trader' do
            it 'gets the fixed sale agreetment text from settings' do
              settings = Settings.instance
              settings[:data][:fixed_sale_agreetment] = 'wherever complicated text'
              settings.save!
              expected_response = {
                'fixed_sale_agreetment' => 'wherever complicated text',
                'buy_agreetment' => ''
              }
              get '/api/v1/agreetments/fixed_sale', {}, 'Authorization' => "Barer #{@token}"
              expect(response.status).to eq 200
              expect(JSON.parse(response.body)).to match(expected_response)
            end
          end

          context 'When the current user role is an Authorized provider ' do
            it 'raises an Unauthorized error because this role doesn\'t use trazoro platform' do
              user = create(
                :user,
                :with_personal_rucom,
                :with_authorized_provider_role,
                email: "testing_#{User.count + 100}@fake.com",
                password: 'super_password',
                password_confirmation: 'super_password'
              )
              token = user.create_token
              expected_response = {
                'fixed_sale_agreetment' => 'wherever complicated text',
                'buy_agreetment' => ''
              }
              expect do
                get '/api/v1/agreetments/fixed_sale', {}, 'Authorization' => "Barer #{token}"
              end.to raise_error 'You are not authorized to access this page.'
            end
          end
        end
      end

      context 'GET' do
        context '/buy_agreetment' do
          context 'When the current user role is a Trader' do
            it 'gets the buy agreetment text from settings' do
              settings = Settings.instance
              settings[:data][:buy_agreetment] = 'wherever complicated text'
              settings.save!
              expected_response = {
                'fixed_sale_agreetment' => '',
                'buy_agreetment' => 'wherever complicated text'
              }
              get '/api/v1/agreetments/buy_agreetment', {}, 'Authorization' => "Barer #{@token}"
              expect(response.status).to eq 200
              expect(JSON.parse(response.body)).to match(expected_response)
            end
          end
        end
      end
    end
  end
end
