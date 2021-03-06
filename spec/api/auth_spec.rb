describe 'Auth', :type => :request do

  describe :v1 do
    context '#login' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
      end

      context 'POST' do
        it 'logs a user in the app' do
          post '/api/v1/auth/login', %Q{email=#{@user.email}&password=super_password}
          expect(response.status).to eq 201
          expect(JSON.parse(response.body)["access_token"]).not_to be_nil
        end

      end
    end
  end
end