describe 'Rucom', :type => :request do

  describe :v1 do
    context 'rucoms' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:rucom, 20, rucom_record: 'ARE_PLU-08141')
        FactoryGirl.create_list(:rucom, 20)
      end

      context 'GET' do

        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/rucoms', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end

        it 'retrieves rucom registries matching rucom_query' do
          rucom_query = 'ARE_PLU-08141'
          get '/api/v1/rucoms', { query_rucom_number: rucom_query, query_name: '' } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 10
        end

        it 'retrieves all rucom registries' do
          per_page = 40
          get '/api/v1/rucoms', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be 40
        end

        context '/:id' do

          it 'gets rucom by id' do
            rucom = Rucom.last
            expected_response = {
              id: rucom.id,
              rucom_record: rucom.rucom_record,
              name: rucom.name,
              status: rucom.status,
              mineral: rucom.mineral,
              location: rucom.location,
              subcontract_number: rucom.subcontract_number,
              mining_permit: rucom.mining_permit,
              provider_type: rucom.provider_type,
              num_rucom: rucom.num_rucom
            }

            get "/api/v1/rucoms/#{rucom.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to match expected_response.stringify_keys
          end
          context "/check_if_available" do
            context "if rucom is already in use by a user or external user" do
              it "responds with an error" do
                rucom = create(:rucom)
                external_user = create(:external_user, personal_rucom: rucom)
                get "/api/v1/rucoms/#{rucom.id}/check_if_available",{},{ "Authorization" => "Barer #{@token}" }
                expect(response.status).to eq 400
              end
            end
            context "if rucom is available" do
              it "responds with a rucom representation" do
                rucom = create(:rucom)
                get "/api/v1/rucoms/#{rucom.id}/check_if_available",{},{ "Authorization" => "Barer #{@token}" }
                expect(response.status).to eq 200
                expected_response = {
                  id: rucom.id,
                  rucom_record: rucom.rucom_record,
                  name: rucom.name
                }
                expect(JSON.parse(response.body)).to include expected_response.stringify_keys
              end
            end
          end
        end
      end
    end
  end
end