describe 'Courier', :type => :request do

  describe :v1 do
    context 'couriers' do

      before :context do
        @user = create :user, :with_company, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:courier, 20)
        FactoryGirl.create(:courier, id_document_number: '1234567890')
      end

      context 'GET' do

        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/couriers', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end

        it 'retrieves a courier matching id_document_number' do
          id_document_number = '1234567890'
          get '/api/v1/couriers', { id_document_number: id_document_number } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 1
        end

        context '/:id' do

          it 'gets courier by id' do

            courier = Courier.last

            expected_response = {
              id: courier.id,
              id_document_number: courier.id_document_number,
              id_document_type: courier.id_document_type,
              first_name: courier.first_name,
              last_name: courier.last_name,
              phone_number: courier.phone_number,
              address: courier.address,
              nit_company_number: courier.nit_company_number,
              company_name: courier.company_name
            }

            get "/api/v1/couriers/#{courier.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end
        end
      end

      context 'POST' do
        it 'returns a representation of the new courier created and code 201' do
          courier = build(:courier)

          new_values = {
            id_document_number: courier.id_document_number,
            id_document_type: courier.id_document_type,
            first_name: courier.first_name,
            last_name: courier.last_name,
            phone_number: courier.phone_number,
            address: courier.address,
            nit_company_number: courier.nit_company_number,
            company_name: courier.company_name
          }

          expected_response = {
            id_document_number: courier.id_document_number,
            id_document_type: courier.id_document_type,
            first_name: courier.first_name,
            last_name: courier.last_name,
            phone_number: courier.phone_number,
            address: courier.address,
            nit_company_number: courier.nit_company_number,
            company_name: courier.company_name
          }

          post '/api/v1/couriers', {courier: new_values}, { "Authorization" => "Barer #{@token}" }

          expect(response.status).to eq 201
          expect(JSON.parse(response.body).except('id')).to match(expected_response.stringify_keys)
        end
      end
      context 'PUT' do
        it 'returns a representation of the updated courier and code 200' do
          courier = create(:courier)


          new_first_name = "A diferent first name"
          new_id_document_number = "1345676788"
          new_nit_company_number = "A direferent nit"

          new_values = {
            id_document_number: new_id_document_number,
            first_name: new_first_name,
            nit_company_number: new_nit_company_number
          }

          expected_response = {
            id_document_number: new_id_document_number,
            id_document_type: courier.id_document_type,
            first_name: new_first_name,
            last_name: courier.last_name,
            phone_number: courier.phone_number,
            address: courier.address,
            nit_company_number: new_nit_company_number,
            company_name: courier.company_name
          }

          put "/api/v1/couriers/#{courier.id}", {id: courier.id, courier: new_values}, { "Authorization" => "Barer #{@token}" }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body).except('id')).to match(expected_response.stringify_keys)
        end
      end
    end

  end

end