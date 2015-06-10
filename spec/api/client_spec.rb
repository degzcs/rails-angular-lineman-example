describe 'Client', :type => :request do

  describe :v1 do
    context 'client' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:client_with_fake_rucom, 20)

           document_number_file_path = "#{Rails.root}/spec/support/test_images/document_number_file.png"
           mining_register_file_path = "#{Rails.root}/spec/support/test_images/mining_register_file.png"
           rut_file_path = "#{Rails.root}/spec/support/test_images/rut_file.png"
           chamber_commerce_file_path = "#{Rails.root}/spec/support/test_images/chamber_of_commerce_file.png"
           photo_file_path = "#{Rails.root}/spec/support/test_images/photo_file.png"
           document_number_file =  Rack::Test::UploadedFile.new(document_number_file_path, "image/jpeg")
           # mining_register_file =  Rack::Test::UploadedFile.new(mining_register_file_path, "image/jpeg")
           rut_file =  Rack::Test::UploadedFile.new(rut_file_path, "image/jpeg")
           chamber_commerce_file = Rack::Test::UploadedFile.new(chamber_commerce_file_path, "image/jpeg")
           photo_file =  Rack::Test::UploadedFile.new(photo_file_path, "image/jpeg")
           @user_files = [photo_file,document_number_file]
           @user_and_company_files = [photo_file,document_number_file, rut_file, chamber_commerce_file]
      end

       context 'GET' do

        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/clients', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end

         context '/:id' do

          it 'gets an client by id' do

            client = User.clients.last

            expected_response = {
              id: client.id,
              document_number: client.document_number,
              first_name: client.first_name,
              last_name: client.last_name,
              phone_number: client.phone_number,
              address: client.address,
              email: client.email,
            }

            get "/api/v1/clients/#{client.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end

      end

      context 'POST' do

      context "without company info" do
          it 'returns a representation of the new client created and code 201' do
            #   file_path = "#{Rails.root}/spec/support/test_images/image.png"
            # @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")

            population_center = create(:population_center)
            client = build(:client_with_fake_rucom, population_center_id: population_center.id)

            new_values = {
              first_name: client.first_name,
              last_name: client.last_name,
              email: client.email,
              document_number: client.document_number,
              document_expedition_date: client.document_expedition_date,
              phone_number: client.phone_number,
              address: client.address,
              population_center_id: population_center.id,
              files: @user_files
            }

            expected_response = {
              document_number: client.document_number,
              first_name: client.first_name,
              last_name: client.last_name,
              phone_number: client.phone_number,
              address: client.address,
              email: client.email,
              activity: 'Joyero'
            }

            post '/api/v1/clients', {client: new_values, activity: 'Joyero'}, { "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 201
            expect(JSON.parse(response.body).except('id')).to include(expected_response.stringify_keys)
          end
        end

        context "with company info" do
          it 'returns a representation of the new client with his company created and code 201' do

            #   file_path = "#{Rails.root}/spec/support/test_images/image.png"
            # @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")

            population_center = create(:population_center)
            client = build(:client_with_fake_rucom, population_center_id: population_center.id)
            company = build(:company)

            new_values = {
              first_name: client.first_name,
              last_name: client.last_name,
              email: client.email,
              document_number: client.document_number,
              document_expedition_date: client.document_expedition_date,
              phone_number: client.phone_number,
              address: client.address,
              population_center_id: population_center.id,
              files: @user_and_company_files
            }

            new_company_values = {
              nit_number: company.nit_number,
              name: company.name,
              city: company.city,
              state: company.state,
              country: company.country,
              legal_representative: company.legal_representative,
              id_type_legal_rep: company.id_type_legal_rep,
              id_number_legal_rep: company.id_number_legal_rep,
              email: company.email,
              phone_number: company.phone_number
            }

            expected_response = {
              document_number: client.document_number,
              first_name: client.first_name,
              last_name: client.last_name,
              phone_number: client.phone_number,
              address: client.address,
              email: client.email,
            }

            post '/api/v1/clients', {client: new_values, company: new_company_values, activity: 'Joyero' },
                                      { "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 201
            expect(JSON.parse(response.body).except('id')).to include(expected_response.stringify_keys)
            #binding.pry
            expect(JSON.parse(response.body)['company']['name']).to eq company.name
            # expect(JSON.parse(response.body)['rucom']['id']).to eq rucom_company.id
          end
        end
      end

      context 'PUT' do
        it 'returns a representation of the updated client and code 200' do
          rucom = create(:rucom)
          population_center = create(:population_center)
          client = create( :client_with_fake_rucom,  population_center_id: population_center.id)

          new_first_name = "A diferent first name"
          new_document_number = "1345676788"
          new_nit_number = "A direferent nit"

          new_values = {
            document_number: new_document_number,
            first_name: new_first_name ,
          }

          new_company_info_values ={
            nit_number: new_nit_number
          }

          expected_response = {
            document_number: new_document_number,
            first_name: new_first_name,
            last_name: client.last_name,
            phone_number: client.phone_number,
            address: client.address,
            email: client.email,
          }

          put "/api/v1/clients/#{client.id}", {client: new_values, company: new_company_info_values}, { "Authorization" => "Barer #{@token}" }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to include(expected_response.stringify_keys)
          expect(JSON.parse(response.body)['company']['nit_number']).to eq new_nit_number
        end
      end

    end
  end

end