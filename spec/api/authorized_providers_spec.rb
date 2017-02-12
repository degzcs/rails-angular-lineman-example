describe 'AuthorizedProviders', type: :request do
  describe :v1 do
    context 'authorized_providers' do
      before :context do
        @user = create :user, :with_company, email: "testing_#{User.count + 100}@fake.com", password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
      end

      context 'GET' do
        context '/:id' do
          it 'gets an authorized provider by id' do
            authorized_provider = create(:user, :with_personal_rucom, :with_profile, :with_authorized_provider_role)

            expected_response = {
              id: authorized_provider.id,
              document_number: authorized_provider.profile.document_number,
              first_name: authorized_provider.profile.first_name,
              last_name: authorized_provider.profile.last_name,
              phone_number: authorized_provider.profile.phone_number,
              address: authorized_provider.profile.address,
              email: authorized_provider.email
            }

            get "/api/v1/authorized_providers/#{authorized_provider.id}", {}, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end

        context '/by_id_number, barequero' do
          it 'gets authorized_provider by id' do
            id_number = '15535725'
            params_from_view = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: id_number }

            VCR.use_cassette('successful_authorized_provider_rucom_response') do
              get '/api/v1/authorized_providers/by_id_number', params_from_view, 'Authorization' => "Barer #{@token}"
            end

            user = Profile.find_by(document_number: id_number).user
            expected_response = {
              'id' => user.id,
              'document_number' => user.profile.document_number,
              'first_name' => user.profile.first_name,
              'last_name' => user.profile.last_name,
              'phone_number' => user.profile.phone_number,
              'address' => user.profile.address,
              'id_document_file' => {"url"=>nil, "preview"=>{"url"=>nil}, "thumb"=>{"url"=>nil}, "medium"=>{"url"=>nil}},
              'rut_file' => {"url"=>nil, "preview"=>{"url"=>nil}, "thumb"=>{"url"=>nil}, "medium"=>{"url"=>nil}},
              'photo_file' => {"url"=>nil, "thumb"=>{"url"=>nil}, "medium"=>{"url"=>nil}},
              'habeas_data_agreetment_file' => {"url"=>nil, "preview"=>{"url"=>nil}, "thumb"=>{"url"=>nil}, "medium"=>{"url"=>nil}},
              'email' => user.email,
              'city' => nil,
              'state' => nil,
              'company' => nil,
              'registration_state' => 'initialized',
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
        it 'returns a representation of the Authorized Provider with the update fields and code 200' do
          user = create :user, :with_profile, :with_personal_rucom
          token = user.create_token
          file_path = "#{Rails.root}/spec/support/images/signature_picture.png"
          signature_picture_file = Rack::Test::UploadedFile.new(file_path, 'image/jpeg')

          file_path = "#{Rails.root}/spec/support/pdfs/habeas_data_agreetment.pdf"
          habeas_data_agreetment_file = Rack::Test::UploadedFile.new(file_path, 'application/pdf')

          file_path = "#{Rails.root}/spec/support/pdfs/id_document_file.pdf"
          id_document_file = Rack::Test::UploadedFile.new(file_path, 'application/pdf')

          file_path = "#{Rails.root}/spec/support/pdfs/rut_file.pdf"
          rut_file = Rack::Test::UploadedFile.new(file_path, 'application/pdf')

          file_path = "#{Rails.root}/spec/support/images/photo_file.png"
          photo_file_file = Rack::Test::UploadedFile.new(file_path, 'image/jpeg')

          city = City.find_by(name: 'RIONEGRO')

          expected_response = {
            'id' => user.id,
            'document_number' => user.profile.document_number,
            'first_name' => 'AMADO',
            'last_name' => 'PRUEBA1 MARULO',
            'phone_number' => '2334455',
            'address' => 'Calle 45 # 34b-56',
            'id_document_file' => generate_document_urls_from(user.profile.id, 'id_document_file'),
            'rut_file' => generate_document_urls_from(user.profile.id, 'rut_file'),
            'photo_file' => generate_photo_urls_from(user.profile.id, 'photo_file'),
            'habeas_data_agreetment_file' => generate_document_urls_from(user.profile.id, 'habeas_data_agreetment', 'habeas_data_agreetment_file'),
            'email' => 'amado.prueba1@barequero.co',
            'city' => JSON.parse(city.to_json).except('created_at', 'updated_at'),
            'state' => JSON.parse(city.state.to_json).except('created_at', 'updated_at'),
            'company' => nil,
            "registration_state" => "completed",
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

          # Data to sent from client to backend
          user_data = { 'email' => 'amado.prueba1@barequero.co' }
          profile_data = {
            'first_name' => 'AMADO',
            'last_name' => 'PRUEBA1 MARULO',
            'phone_number' => '2334455',
            'address' => 'Calle 45 # 34b-56',
            'city_id' => city.id || nil
          }
          rucom_data = { 'rucom_number' => '987654321' }
          files = [photo_file_file, id_document_file, rut_file, signature_picture_file, habeas_data_agreetment_file]

          params_set = { 'authorized_provider' => user_data, 'profile' => profile_data, 'rucom' => rucom_data, 'files' => files }

          put "/api/v1/authorized_providers/#{user.id}", params_set, 'Authorization' => "Barer #{token}"

          res = JSON.parse(response.body)
          # it Removes the datetime attributes to make coincid the hashes
          res['rucom'].except!('created_at', 'updated_at')
          res['city'].except!('created_at', 'updated_at')
          res['state'].except!('created_at', 'updated_at')

          expect(response.status).to eq 200
          expect(res).to match expected_response

          # Those are to test the audit actions on users table and you can check out on audits table
          audit_comment = "Updated from API Request by ID: #{user.id}"
          expect(user.audits[1].user).to eq(user)
          expect(user.audits[1].comment).to eq(audit_comment)

          # Those are to test the audit actions on users profile table and you can check out on audits table
          expect(user.profile.audits.last.user).to be_nil
          expect(user.profile.audits.last.action).to eq('update')
          expect(user.profile.audits.last.comment).to be_nil
        end
      end

      context 'PUT' do
        it '/update_basic_info/:id' do
          user = create :user, :with_profile, :with_authorized_provider_role, :with_personal_rucom
          token = user.create_token
          params = {
            'authorized_provider' => {
              'email' => 'amado@gmail.com'
            },
            'profile' => {
              'address' => 'calle 45',
              'phone_number' => '3456789'
            }
          }
          put "/api/v1/authorized_providers/update_basic_info/#{user.id}", params, 'Authorization' => "Barer #{token}"
          res = JSON.parse(response.body)
          expect(response.status).to eq 200
          expect(res['email']).to match params['authorized_provider']['email']
          expect(res['address']).to match params['profile']['address']
          expect(res['phone_number']).to match params['profile']['phone_number']
        end
      end
    end
  end
end
