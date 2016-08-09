describe 'Auth', :type => :request do
  describe :v1 do
    context '#me' do
      context 'GET' do
        it 'show the user info, this user dont have company' do
          user = create :user, :with_profile, :with_personal_rucom, :with_trader_role, nit_number: nil
          token = user.create_token
          expected_response = {
           'id' => user.id,
           'first_name' => user.profile.first_name,
           'last_name' => user.profile.last_name,
           'nit' => nil, # NOTE: This field is not mandatory because not all barequeros have this document, they should but they dont have it.
           'email' => user.email,
           'document_number' => user.profile.document_number,
           #'access_token'=> token,
           'available_credits' => user.profile.available_credits,
           'phone_number' => user.profile.phone_number,
           'address' => user.profile.address,
           'office' => nil,
           'company_name' => nil,
           'company' => nil,
           'photo_file' => {
             'url' => "/uploads/photos/profile/photo_file/#{ user.profile.id }/photo_file.png"
            },
          }

          get '/api/v1/users/me', {}, {'Authorization' => "Barer #{token}"}
          expect(response.status).to eq 200
          expected_response.each do |key, value|
            expect(JSON.parse(response.body)[key]).to eq value
          end
        end
        # Exportador --> role
        # certificado de origen

        it 'should to check if a user belonging to a company is showing a correct information' do
          user = create :user, :with_profile, :with_company, available_credits: 0
          company = user.company
          company.legal_representative.profile.update_column :available_credits, 100
          company.reload
          token = user.create_token

          expected_company = {
             'city' => company.city.name,
             'state' => company.state.name,
             'country' => company.state.country.name,
             'email' => company.email,
             'external' => company.external,
             'id' => company.id,
             'legal_representative_id' => company.legal_representative_id,
             'name' => company.name,
             'nit_number' => company.nit_number,
             'phone_number' => company.phone_number,
             'mining_register_file' => {
              'url'=>"/uploads/documents/company/mining_register_file/#{ company.id }/mining_register_file.pdf"},
             'rut_file' => {
              'url'=>"/uploads/documents/company/rut_file/#{ company.id }/rut_file.pdf"
              },
            'chamber_of_commerce_file' => {
              'url'=>"/uploads/documents/company/chamber_of_commerce_file/#{ company.id }/photo_file.png"
              },
          }

           expected_response = {
           'id'=> user.id,
           'first_name' => user.profile.first_name,
           'last_name' => user.profile.last_name,
           'nit' => user.profile.nit_number,
           'email' => user.email,
           'document_number' => user.profile.document_number,
           #'access_token'=> token,
           'available_credits' => company.available_credits,
           'phone_number' => user.profile.phone_number,
           'address' => user.profile.address,
           'office' => user.office.name,
           'company_name' => company.name,
           'company' => expected_company,
           'photo_file' => {
             'url' => "/uploads/photos/profile/photo_file/#{ user.profile.id }/photo_file.png"
            },
          }

          get '/api/v1/users/me', {},{ 'Authorization' => "Barer #{ token }" }
          expect(response.status).to eq 200
          expected_response.each do |key, value|
            if key == 'company'
              expected_company.each do |ckey , cvalue|
                expect(JSON.parse(response.body)['company'][ckey]).to eq cvalue
              end
            else
              expect(JSON.parse(response.body)[key]).to eq value
            end
          end
        end

        it 'should to check if the legal representative inforamtion is correct' do
          user = create :user, :with_profile, legal_representative: true, office: nil, available_credits: 100
          company = create :company, legal_representative: user
          user.update_column :office_id, company.main_office.id
          user.reload
          token = user.create_token

          expected_company = {
             'city' => company.city.name,
             'state' => company.state.name,
             'country' => company.state.country.name,
             'email' => company.email,
             'external' => company.external,
             'id' => company.id,
             'legal_representative_id' => company.legal_representative_id,
             'name' => company.name,
             'nit_number' => company.nit_number,
             'phone_number' => company.phone_number,
             'mining_register_file' => {
              'url' => "/uploads/documents/company/mining_register_file/#{ company.id }/mining_register_file.pdf"},
             'rut_file' => {
              'url' => "/uploads/documents/company/rut_file/#{ company.id }/rut_file.pdf"
              },
            'chamber_of_commerce_file' => {
              'url' => "/uploads/documents/company/chamber_of_commerce_file/#{ company.id }/photo_file.png"
              },
          }

          expected_response = {
           'id'=> user.id,
           'first_name' => user.profile.first_name,
           'last_name' => user.profile.last_name,
           'nit' => user.profile.nit_number,
           'email' => user.email,
           'document_number' => user.profile.document_number,
           #'access_token'=> token,
           'available_credits' => company.available_credits,
           'phone_number' => user.profile.phone_number,
           'address' => user.profile.address,
           'office' => user.office.name,
           'company_name' => company.name,
           'company' => expected_company,
           'photo_file' => {
             'url' => "/uploads/photos/profile/photo_file/#{ user.profile.id }/photo_file.png"
            },
          }

          get '/api/v1/users/me', {},{ 'Authorization' => "Barer #{ token }" }
          expect(response.status).to eq 200
          expected_response.each do |key, value|
            if key == 'company'
              expected_company.each do |ckey , cvalue|
                expect(JSON.parse(response.body)['company'][ckey]).to eq cvalue
              end
            else
              expect(JSON.parse(response.body)[key]).to eq value
            end
          end
        end
      end

      context 'UPDATE' do
        it 'should update the current user info' do
          user = create :user, :with_personal_rucom
          token = user.create_token

          expected_response = {
           'id' => user.id,
           'first_name' => 'Armando',
           'last_name' => 'Casas',
           'email' => 'armando.casas@fake.com',
           'available_credits' => user.available_credits
          }

          new_values ={
           'first_name' => 'Armando',
           'last_name' => 'Casas',
           'email' => 'armando.casas@fake.com',
          }
          put '/api/v1/users/', {user: new_values},{ 'Authorization' => "Barer #{token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to include expected_response
        end
      end
    end
  end
end