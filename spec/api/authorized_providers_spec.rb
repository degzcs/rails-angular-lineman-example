describe 'AuthorizedProviders', type: :request do
  describe :v1 do
    context 'authorized_providers' do
      before :context do
        @user = create :user, :with_company, email: "testing_#{User.count + 100}@fake.com", password: 'super_password', password_confirmation: 'super_password'
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
              'provider_type' => user.rucom.provider_type
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

          #
          # formato del params enviado desde el frontend
          #
          # {
          #   "data" => "{\"authorized_provider\":{\"email\":\"amado1@prueba.com.co\"},\"profile\":{\"first_name\":\"AMADO\",\"document_number\":\"\",\"last_name\":\"MARULANDA\",\"phone_number\":\"2334455\",\"address\":\"call 12\",\"city_id\":\"\",\"photo_file\":{\"name\":\"photo_file.png\"}},\"rucom\":{\"rucom_number\":\"987654321\"}}",
          #   "id" => "5"
          # }

          user_vals = { 'email' => 'amado.prueba1@barequero.co' }
          files = [photo_file, id_document_file, mining_authorization_file]
          profile = {
            'first_name' => 'AMADO',
            'last_name' => 'PRUEBA1 MARULO',
            'phone_number' => '2334455',
            'address' => 'Calle 45 # 34b-56',
            'id_document_file' => '',
            'mining_authorization_file' => '',
            'photo_file' => '',
            'city_id' => city.id || nil,
            'files' => files
          }
          rucom = { 'rucom_number' => '987654321' }
          
          url_base = "/test/uploads"
          document_number_file_url = "/documents/profile/id_document_file/#{user.id}/document_number_file.pdf"
          mining_register_file_url = "/documents/profile/mining_authorization_file/#{user.id}/mining_register_file.pdf"
          photo_file = "/photos/profile/photo_file/#{user.id}/photo_file.png"
          
          expected_response = {
            'id' => user.id,
            'document_number' => user.profile.document_number,
            'first_name' => 'AMADO',
            'last_name' => 'PRUEBA1 MARULO',
            'phone_number' => '2334455',
            'address' => 'Calle 45 # 34b-56',
            'document_number_file' => { 'url' => url_base + document_number_file_url },
            'mining_register_file' => { 'url' => url_base + mining_register_file_url },
            'photo_file' => { 'url' => url_base + photo_file },
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
          params_set = { 'authorized_provider' => user_vals, 'profile' => profile, 'rucom' => rucom }
          put "/api/v1/autorized_providers/#{user.id}", params_set, { "Authorization" => "Barer #{token}" }

          res = JSON.parse(response.body)
          # it Removes the datetime attributes to make coincid the hashes
          res['rucom'].except!('created_at', 'updated_at')
          res['city'].except!('created_at', 'updated_at')
          res['state'].except!('created_at', 'updated_at')

          expect(response.status).to eq 200
          expect(res).to match expected_response
        end
      end
    end
  end
end
