describe 'AuthorizedProviders', type: :request do
  describe :v1 do
    context 'authorized_providers' do
      before :context do
        @user = create :user, :with_company, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'GET' do
        # it 'retrieves all city registries' do
        #   get '/api/v1/authorized_providers', {}, 'Authorization' => "Barer #{@token}"
        #   expect(response.status).to eq 200
        #   expect(JSON.parse(response.body).count).to be 565
        # end

        context '/:id_number' do
          it 'gets authorized_provider by id' do
            id_number = '15535725'
            params_from_view = { id_type: 'CEDULA', rol_name: 'Barequero' }

            profile = Profile.find_by(document_number: id_number)
            expected_response = {
              id: profile.id,
              first_name: profile.first_name,
              last_name: profile.last_name,
              document_number: profile.document_number
            }

            get "/api/v1/authorized_providers/#{id_number}", params_from_view, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end
        end
      end
    end
  end
end
