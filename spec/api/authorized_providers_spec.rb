describe 'AuthorizedProviders', type: :request do
  describe :v1 do
    context 'authorized_providers' do
      before :context do
        @user = create :user, :with_company, email: "testing_#{ User.count + 100 }@fake.com", password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'GET' do
        context '/by_id_number' do
          it 'gets authorized_provider by id' do
            id_number = '15535725'
            params_from_view = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: id_number }

            get '/api/v1/autorized_providers/by_id_number', params_from_view, 'Authorization' => "Barer #{@token}"

            user = Profile.find_by(document_number: id_number).user
            expected_response = {
              'id' => user.id,
              'document_number' => user.profile.document_number,
              'first_name' => user.profile.first_name,
              'last_name' => user.profile.last_name,
              'phone_number' => user.profile.phone_number,
              'address' => user.profile.address,
              'document_number_file' => { 'url' => nil },
              'mining_register_file' => { 'url' => nil },
              'photo_file' => { 'url' => nil },
              'email' => user.email,
              'city' => nil,
              'state' => nil,
              'company' => nil,
              'rucom' => {
                'id' => user.rucom.id,
                'rucom_number' => user.rucom.rucom_number,
                'name' => user.rucom.name,
                'original_name' => user.rucom.original_name,
                'minerals' => user.rucom.minerals,
                'location' => user.rucom.location,
                'status' => user.rucom.status,
                'provider_type' => user.rucom.provider_type,
                'rucomeable_type' => user.rucom.rucomeable_type,
                'rucomeable_id' => user.rucom.rucomeable_id
              },
              'provider_type' => nil
            }

            res = JSON.parse(response.body)
            res['rucom'].except!('created_at', 'updated_at')

            expect(response.status).to eq 200
            expect(res).to match expected_response
          end
        end
      end

      context 'PUT' do
        it 'returns a representation of the Autorized Provider with the update fields and code 200' do
          user = create :user, :with_profile, :with_personal_rucom
          token = user.create_token

          file_path = "#{Rails.root}/spec/support/pdfs/document_number_file.pdf"
          id_document_file = Rack::Test::UploadedFile.new(file_path, 'application/pdf')

          file_path = "#{Rails.root}/spec/support/pdfs/mining_register_file.pdf"
          mining_authorization_file = Rack::Test::UploadedFile.new(file_path, 'application/pdf')

          file_path = "#{Rails.root}/spec/support/images/image.png"
          photo_file = Rack::Test::UploadedFile.new(file_path, 'image/jpeg')

          city = City.find('85')
          # new_values ={ user: { email: 'amado.prueba1@barequero.co' },
          #   profile: {
          #     first_name: 'AMADO',
          #     last_name: 'PRUEBA1 MARULO',
          #     phone_number: '2334455',
          #     address: 'Calle 45 # 34b-56',
          #     id_document_file: id_document_file,
          #     mining_authorization_file: mining_authorization_file,
          #     photo_file: photo_file,
          #     city_id: city.id || nil
          #   },
          # #  state: nil,
          # #  company: nil,
          #   rucom: { rucom_number: '987654321' }
          # }

          user_vals = { email: 'amado.prueba1@barequero.co' }
          profile = {
            first_name: 'AMADO',
            last_name: 'PRUEBA1 MARULO',
            phone_number: '2334455',
            address: 'Calle 45 # 34b-56',
            id_document_file: id_document_file,
            mining_authorization_file: mining_authorization_file,
            photo_file: photo_file,
            city_id: city.id || nil
          }
          rucom = { rucom_number: '987654321' }
          
          expected_response = {
                        'id' => user.id,
                 'document_number' => user.profile.document_number,
                      'first_name' => 'AMADO',
                       'last_name' => 'PRUEBA1 MARULO',
                    'phone_number' => '2334455',
                         'address' => 'Calle 45 # 34b-56',
            'document_number_file' => { 'url'=>  "/test/uploads/documents/profile/id_document_file/#{user.id}/document_number_file.pdf"}, #{ 'url' => user.profile.id_document_file_url },
            'mining_register_file' => { 'url' => "/test/uploads/documents/profile/mining_authorization_file/#{user.id}/mining_register_file.pdf"}, #{ 'url' => user.profile.mining_register_file.url },
                      'photo_file' => { 'url' => "/test/uploads/photos/profile/photo_file/#{user.id}/image.png" }, #{ 'url' => user.profile.photo_file.url },
                           'email' => 'amado.prueba1@barequero.co',
                            'city' => JSON.parse(city.to_json).except('created_at', 'updated_at'),
                           'state' => JSON.parse(city.state.to_json).except('created_at', 'updated_at'),
                         'company' => nil,
                           'rucom' => {
                                         'id' => user.rucom.id,
                               'rucom_number' => '987654321',
                                       'name' => user.rucom.name,
                              'original_name' => user.rucom.original_name,
                                   'minerals' => user.rucom.minerals,
                                   'location' => user.rucom.location,
                                     'status' => user.rucom.status,
                              'provider_type' => user.rucom.provider_type,
                            'rucomeable_type' => user.rucom.rucomeable_type,
                              'rucomeable_id' => user.rucom.rucomeable_id
                                      },
                   'provider_type' => user.rucom.provider_type
            }

          params_to_set = {authorized_provider: user_vals, profile: profile, rucom: rucom}
          put "/api/v1/autorized_providers/#{user.id}", params_to_set, { "Authorization" => "Barer #{token}" }
          # put "/api/v1/autorized_providers/#{@user.id}", {authorized_provider: new_values, profile: new_company_info_values}, { "Authorization" => "Barer #{@token}" }

          res = JSON.parse(response.body)
          # it Removes the datetime attributes to make coincid the hashes
          res['rucom'].except!('created_at', 'updated_at')
          res['city'].except!('created_at', 'updated_at')
          res['state'].except!('created_at', 'updated_at')

          expect(response.status).to eq 200
          expect(res).to match expected_response

          # expect(response.status).to eq 200
          # expect(JSON.parse(response.body)).to include(expected_response.stringify_keys)
          # expect(JSON.parse(response.body)['profile']['nit_number']).to eq new_nit_number
        end
      end
    end
  end
end
