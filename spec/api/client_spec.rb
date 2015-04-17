describe 'Client', :type => :request do

  describe :v1 do
    context 'clients' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:client, 20,{rucom_id: FactoryGirl.create(:rucom).id, population_center_id: FactoryGirl.create(:population_center).id})
      end

      context 'GET' do

        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/clients', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end
        
        context '/:id' do

          it 'gets client by id' do 

            client = Client.last

            expected_rucom = {
              id: client.rucom.id,
              status: client.rucom.status,
              num_rucom: client.rucom.num_rucom,
              rucom_record: client.rucom.rucom_record,
              provider_type: client.rucom.provider_type,
              mineral: client.rucom.mineral
            }

            expected_population_center = {
              id: client.population_center.id,
              name: client.population_center.name,
              population_center_code: client.population_center.population_center_code
            }

            expected_response = {
              id: client.id,
              id_document_number: client.id_document_number,
              id_document_type: client.id_document_type,
              first_name: client.first_name,
              last_name: client.last_name,
              phone_number: client.phone_number,
              address: client.address,
              email: client.email,
              company_name: client.company_name,
              nit_company_number: client.nit_company_number,
              client_type: client.client_type,
              rucom: expected_rucom.stringify_keys,
              population_center: expected_population_center.stringify_keys
            }

            get "/api/v1/clients/#{client.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end
        end
      end

      context 'POST' do
        context "create a new client" do
          it 'returns a representation of the new client created and code 201' do
            #   file_path = "#{Rails.root}/spec/support/test_images/image.png"
            # @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")

            rucom = create(:rucom)
            population_center = create(:population_center)
            client = build( :client,rucom_id: rucom.id, population_center_id: population_center.id)

            new_values = {
              id_document_number: client.id_document_number,
              id_document_type: client.id_document_type,
              first_name: client.first_name,
              last_name: client.last_name,
              phone_number: client.phone_number,
              address: client.address,              
              email: client.email,
              company_name: client.company_name,
              nit_company_number: client.nit_company_number,
              client_type: client.client_type,
              rucom_id: rucom.id,
              population_center_id: population_center.id
            }           
            
            expected_rucom = {
              id: client.rucom.id,
              status: client.rucom.status,
              num_rucom: client.rucom.num_rucom,
              rucom_record: client.rucom.rucom_record,
              provider_type: client.rucom.provider_type,
              mineral: client.rucom.mineral
            }

            expected_population_center = {
              id: client.population_center.id,
              name: client.population_center.name,
              population_center_code: client.population_center.population_center_code
            }

            expected_response = {
              id_document_number: client.id_document_number,
              id_document_type: client.id_document_type,
              first_name: client.first_name,
              last_name: client.last_name,
              phone_number: client.phone_number,
              address: client.address,
              email: client.email,
              company_name: client.company_name,
              nit_company_number: client.nit_company_number,
              client_type: client.client_type,
              rucom: expected_rucom.stringify_keys,
              population_center: expected_population_center.stringify_keys
            }

            post '/api/v1/clients', {client: new_values}, { "Authorization" => "Barer #{@token}" }

            expect(response.status).to eq 201
            expect(JSON.parse(response.body).except('id')).to match(expected_response.stringify_keys)
          end
        end
      end
      context 'PUT' do
        it 'returns a representation of the updated client and code 200' do
          rucom = create(:rucom)         
          population_center = create(:population_center)
          client = create( :client,rucom_id: rucom.id, population_center_id: population_center.id)


          new_first_name = "A diferent first name"
          new_document_number = "1345676788"
          
          new_values = {
            id_document_number: new_document_number,
            first_name: new_first_name ,
          }

          expected_rucom = {
            id: client.rucom.id,
            status: client.rucom.status,
            num_rucom: client.rucom.num_rucom,
            rucom_record: client.rucom.rucom_record,
            provider_type: client.rucom.provider_type,
            mineral: client.rucom.mineral
          }

          expected_population_center = {
            id: client.population_center.id,
            name: client.population_center.name,
            population_center_code: client.population_center.population_center_code
          }

          expected_response = {
            id_document_number: new_document_number,
            id_document_type: client.id_document_type,
            first_name: new_first_name,
            last_name: client.last_name,
            phone_number: client.phone_number,
            address: client.address,
            email: client.email,
            company_name: client.company_name,
            nit_company_number: client.nit_company_number,
            client_type: client.client_type,
            rucom: expected_rucom.stringify_keys,
            population_center: expected_population_center.stringify_keys
          }

          put "/api/v1/clients/#{client.id}", {id: client.id, client: new_values}, { "Authorization" => "Barer #{@token}" }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body).except('id')).to match(expected_response.stringify_keys)
        end
      end
    end

  end

end