describe 'Client', :type => :request do

  describe :v1 do
    context 'client' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        # FactoryGirl.create_list(:client, 20)

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

      context 'POST' do

      context "without company info" do
          it 'returns a representation of the new external user created and code 201' do
            #   file_path = "#{Rails.root}/spec/support/test_images/image.png"
            # @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")

            population_center = create(:population_center)
            client = build(:external_user, population_center_id: population_center.id)

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
          xit 'returns a representation of the new external user with his company created and code 201' do

            #   file_path = "#{Rails.root}/spec/support/test_images/image.png"
            # @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")

            rucom_company = create(:rucom)
            population_center = create(:population_center)
            external_user = build(:external_user, population_center_id: population_center.id)
            company = build(:company)

            new_values = {
              first_name: external_user.first_name,
              last_name: external_user.last_name,
              email: external_user.email,
              document_number: external_user.document_number,
              document_expedition_date: external_user.document_expedition_date,
              phone_number: external_user.phone_number,
              address: external_user.address,
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
              document_number: external_user.document_number,
              first_name: external_user.first_name,
              last_name: external_user.last_name,
              phone_number: external_user.phone_number,
              address: external_user.address,
              email: external_user.email,
            }

            post '/api/v1/external_users', {external_user: new_values, rucom_id: rucom_company.id, company: new_company_values},
                                      { "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 201
            expect(JSON.parse(response.body).except('id')).to include(expected_response.stringify_keys)
            #binding.pry
            expect(JSON.parse(response.body)['company']['name']).to eq company.name
            expect(JSON.parse(response.body)['rucom']['id']).to eq rucom_company.id
          end
        end
      end


    end
  end

end