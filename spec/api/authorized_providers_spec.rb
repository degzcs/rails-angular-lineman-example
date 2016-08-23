describe 'AuthorizedProviders', type: :request do
  describe :v1 do
    context 'authorized_providers' do
      before :context do
        @user = create :user, :with_company, email: "testing_#{ User.count + 100 }@fake.com", password: 'super_password', password_confirmation: 'super_password'
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
                   'provider_type' => nil
            }

            res = JSON.parse(response.body)
            res['rucom'].except!('created_at', 'updated_at')

            expect(response.status).to eq 200
            expect(res).to match expected_response
          end
        end
      end
    end
  end
end
