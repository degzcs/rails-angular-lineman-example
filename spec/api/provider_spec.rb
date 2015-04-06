describe 'Provider', :type => :request do

  describe :v1 do
    context 'providers' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:provider, 20,{company_info: nil, rucom_id: FactoryGirl.create(:rucom).id, population_center_id: FactoryGirl.create(:population_center).id})
           file_path = "#{Rails.root}/spec/support/test_images/image.png"
        @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")
      end

      context 'GET' do

        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/providers', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end
        
        context '/:id' do

          it 'gets provider by id' do 

            provider = Provider.last

            expected_rucom = {
              id: provider.rucom.id,
              status: provider.rucom.status,
              num_rucom: provider.rucom.num_rucom,
              rucom_record: provider.rucom.rucom_record,
              provider_type: provider.rucom.provider_type,
              mineral: provider.rucom.mineral
            }

            expected_population_center = {
              id: provider.population_center.id,
              name: provider.population_center.name,
              population_center_code: provider.population_center.population_center_code
            }

            expected_response = {
              id: provider.id,
              document_number: provider.document_number,
              first_name: provider.first_name,
              last_name: provider.last_name,
              phone_number: provider.phone_number,
              address: provider.address,
              photo_file: provider.photo_file_url,
              email: provider.email,
              rucom: expected_rucom.stringify_keys,
              population_center: expected_population_center.stringify_keys
            }

            get "/api/v1/providers/#{provider.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end
        end
      end

      context 'POST' do
        context "without company_info" do
          it 'returns a representation of the new provider created and code 201' do
              file_path = "#{Rails.root}/spec/support/test_images/image.png"
            @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")

            rucom = create(:rucom)
            population_center = create(:population_center)
            provider = build( :provider,rucom_id: rucom.id, population_center_id: population_center.id)

            new_values = {
              document_number: provider.document_number,
              first_name: provider.first_name,
              last_name: provider.last_name,
              phone_number: provider.phone_number,
              address: provider.address,
              rucom_id: rucom.id,
              population_center_id: population_center.id,
              photo_file: @file,
              email: provider.email
            }           
            
            expected_rucom = {
              id: provider.rucom.id,
              status: provider.rucom.status,
              num_rucom: provider.rucom.num_rucom,
              rucom_record: provider.rucom.rucom_record,
              provider_type: provider.rucom.provider_type,
              mineral: provider.rucom.mineral
            }

            expected_population_center = {
              id: provider.population_center.id,
              name: provider.population_center.name,
              population_center_code: provider.population_center.population_center_code
            }

            expected_response = {
              document_number: provider.document_number,
              first_name: provider.first_name,
              last_name: provider.last_name,
              phone_number: provider.phone_number,
              address: provider.address,
              photo_file: "#{Rails.root}/spec/uploads/provider/photo_file/21/image.png",
              email: provider.email,
              rucom: expected_rucom.stringify_keys,
              population_center: expected_population_center.stringify_keys
            }

            post '/api/v1/providers', {provider: new_values}, { "Authorization" => "Barer #{@token}" }

            expect(response.status).to eq 201
            expect(JSON.parse(response.body).except('id')).to match(expected_response.stringify_keys)
          end
        end
        context "with company info" do
          it 'returns a representation of the new provider with his company_info created and code 201' do
            
              file_path = "#{Rails.root}/spec/support/test_images/image.png"
            @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")

            rucom = create(:rucom)
            population_center = create(:population_center)
            provider = build( :provider,rucom_id: rucom.id, population_center_id: population_center.id)

            new_values = {
              document_number: provider.document_number,
              first_name: provider.first_name,
              last_name: provider.last_name,
              phone_number: provider.phone_number,
              address: provider.address,
              photo_file: @file,
              email: provider.email,
              rucom_id: rucom.id,
              population_center_id: population_center.id,
            }

            new_company_info_values = {
              id: 123,
              nit_number: provider.company_info.nit_number,
              name: provider.company_info.name,
              city: provider.company_info.city,
              state: provider.company_info.state,
              country: provider.company_info.country,
              legal_representative: provider.company_info.legal_representative,
              id_type_legal_rep: provider.company_info.id_type_legal_rep,
              email: provider.company_info.email,
              phone_number: provider.company_info.phone_number
            }

            expected_rucom = {
              id: provider.rucom.id,
              status: provider.rucom.status,
              num_rucom: provider.rucom.num_rucom,
              rucom_record: provider.rucom.rucom_record,
              provider_type: provider.rucom.provider_type,
              mineral: provider.rucom.mineral
            }

            expected_population_center = {
              id: provider.population_center.id,
              name: provider.population_center.name,
              population_center_code: provider.population_center.population_center_code              
            }

            expected_company_info = {
              id: 123,
              nit_number: provider.company_info.nit_number,
              name: provider.company_info.name,
              legal_representative: provider.company_info.legal_representative,
              id_type_legal_rep: provider.company_info.id_type_legal_rep,
              email: provider.company_info.email,
              phone_number: provider.company_info.phone_number
            }

            expected_response = {
              document_number: provider.document_number,
              first_name: provider.first_name,
              last_name: provider.last_name,
              phone_number: provider.phone_number,
              address: provider.address,
              photo_file: "#{Rails.root}/spec/uploads/provider/photo_file/22/image.png",
              email: provider.email,
              rucom: expected_rucom.stringify_keys,
              company_info: expected_company_info.stringify_keys,
              population_center: expected_population_center.stringify_keys
            }

            post '/api/v1/providers', {provider: new_values, company_info: new_company_info_values},
                                      { "Authorization" => "Barer #{@token}" }

            expect(response.status).to eq 201
            expect(JSON.parse(response.body).except('id')).to match(expected_response.stringify_keys)
          end
        end
      end
      context 'PUT' do
        it 'returns a representation of the updated provider and code 200' do
          rucom = create(:rucom)         
          population_center = create(:population_center)
          provider = create( :provider,rucom_id: rucom.id, population_center_id: population_center.id)


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

          expected_rucom = {
            id: provider.rucom.id,
            status: provider.rucom.status,
            num_rucom: provider.rucom.num_rucom,
            rucom_record: provider.rucom.rucom_record,
            provider_type: provider.rucom.provider_type,
            mineral: provider.rucom.mineral
          }

          expected_company_info = {
            id: provider.company_info.id,
            nit_number: new_nit_number,
            name: provider.company_info.name,
            legal_representative: provider.company_info.legal_representative,
            id_type_legal_rep: provider.company_info.id_type_legal_rep,
            email: provider.company_info.email,
            phone_number: provider.company_info.phone_number
          }

          expected_population_center = {
            id: provider.population_center.id,
            name: provider.population_center.name,
            population_center_code: provider.population_center.population_center_code
          }

          expected_response = {
            document_number: new_document_number,
            first_name: new_first_name,
            last_name: provider.last_name,
            phone_number: provider.phone_number,
            address: provider.address,
            photo_file: provider.photo_file_url,
            email: provider.email,
            rucom: expected_rucom.stringify_keys,
            company_info: expected_company_info.stringify_keys,
            population_center: expected_population_center.stringify_keys
          }

          put "/api/v1/providers/#{provider.id}", {id: provider.id, provider: new_values, company_info: new_company_info_values}, { "Authorization" => "Barer #{@token}" }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body).except('id')).to match(expected_response.stringify_keys)
        end
      end
    end

  end

end