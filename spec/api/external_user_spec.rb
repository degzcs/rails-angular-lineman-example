describe 'ExternalUser', :type => :request do

  describe :v1 do
    context 'authorized_provider' do

      before :context do
        @user = create :user, :with_company
        @token = @user.create_token
        create_list(:user, :with_authorized_provider_role, 20)

           document_number_file_path = "#{Rails.root}/spec/support/images/document_number_file.png"
           mining_register_file_path = "#{Rails.root}/spec/support/images/mining_register_file.png"
           rut_file_path = "#{Rails.root}/spec/support/images/rut_file.png"
           chamber_commerce_file_path = "#{Rails.root}/spec/support/images/chamber_of_commerce_file.png"
           photo_file_path = "#{Rails.root}/spec/support/images/photo_file.png"
           document_number_file = Rack::Test::UploadedFile.new(document_number_file_path, "image/jpeg")
           mining_register_file = Rack::Test::UploadedFile.new(mining_register_file_path, "image/jpeg")
           rut_file = Rack::Test::UploadedFile.new(rut_file_path, "image/jpeg")
           chamber_commerce_file = Rack::Test::UploadedFile.new(chamber_commerce_file_path, "image/jpeg")
           photo_file = Rack::Test::UploadedFile.new(photo_file_path, "image/jpeg")
           @user_files = [photo_file,document_number_file]
           @user_and_company_files = [photo_file,document_number_file, mining_register_file, rut_file, chamber_commerce_file]
      end

      context 'GET' do

        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/external_users', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end

        # context '/:id' do

        #   it 'gets an external user by id' do

        #     external_user = User.external_users.last

        #     expected_response = {
        #       id: external_user.id,
        #       document_number: external_user.profile.document_number,
        #       first_name: external_user.profile.first_name,
        #       last_name: external_user.profile.last_name,
        #       phone_number: external_user.profile.phone_number,
        #       address: external_user.profile.address,
        #       email: external_user.email,
        #     }

        #     get "/api/v1/external_users/#{external_user.id}",{},{ "Authorization" => "Barer #{@token}" }
        #     expect(response.status).to eq 200
        #     expect(JSON.parse(response.body)).to include expected_response.stringify_keys
        #   end
        # end
      end

      context 'POST (this specs will be deprecated, the external users will be created from the backend)' do

        context "without rucom" do
          it 'returns a representation of the new external user created and code 201' do
            #   file_path = "#{Rails.root}/spec/support/images/image.png"
            # @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")
            rucom = create :rucom, provider_type: 'Barequero'

            external_user = build(:external_user)

            new_values = {
              email: external_user.email,
              files: @user_files,
              first_name: external_user.profile.first_name,
              last_name: external_user.profile.last_name,
              document_number: external_user.profile.document_number,
              phone_number: external_user.profile.phone_number,
              address: external_user.profile.address,
              city_id: City.last.id
            }

            expected_response = {
              document_number: external_user.profile.document_number,
              first_name: external_user.profile.first_name,
              last_name: external_user.profile.last_name,
              phone_number: external_user.profile.phone_number,
              address: external_user.profile.address,
              email: external_user.email
            }

            post '/api/v1/external_users', {external_user: new_values, rucom_id: rucom.id}, { "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 201
            expect(JSON.parse(response.body).except('id')).to include(expected_response.stringify_keys)
          end
        end

        xcontext "without company info" do
          xit 'returns a representation of the new external user created and code 201' do
            #   file_path = "#{Rails.root}/spec/support/images/image.png"
            # @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")

            rucom = create(:rucom)
            population_center = create(:population_center)
            external_user = build(:external_user, personal_rucom: rucom, population_center_id: population_center.id)

            new_values = {
              first_name: external_user.first_name,
              last_name: external_user.last_name,
              email: external_user.email,
              document_number: external_user.document_number,
              document_expedition_date: external_user.document_expedition_date,
              phone_number: external_user.phone_number,
              address: external_user.address,
              population_center_id: population_center.id,
              files: @user_files
            }

            expected_response = {
              document_number: external_user.document_number,
              first_name: external_user.first_name,
              last_name: external_user.last_name,
              phone_number: external_user.phone_number,
              address: external_user.address,
              email: external_user.email
            }

            post '/api/v1/external_users', {external_user: new_values, rucom_id: rucom.id}, { "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 201
            expect(JSON.parse(response.body).except('id')).to include(expected_response.stringify_keys)
          end
        end

        xcontext "with company info" do
          xit 'returns a representation of the new external user with his company created and code 201' do

            #   file_path = "#{Rails.root}/spec/support/images/image.png"
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

      xcontext 'PUT (This is deprecated, the external user will be updated from the backend)' do
        it 'returns a representation of the updated external user and code 200' do
          rucom = create(:rucom)
          population_center = create(:population_center)
          external_user = create( :external_user, personal_rucom: rucom, population_center_id: population_center.id)

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
            last_name: external_user.last_name,
            phone_number: external_user.phone_number,
            address: external_user.address,
            email: external_user.email,
          }

          put "/api/v1/external_users/#{external_user.id}", {external_user: new_values, company: new_company_info_values}, { "Authorization" => "Barer #{@token}" }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to include(expected_response.stringify_keys)
          expect(JSON.parse(response.body)['company']['nit_number']).to eq new_nit_number
        end
      end
    end

  end

end