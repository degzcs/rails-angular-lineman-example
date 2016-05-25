describe 'Auth', :type => :request do

  describe :v1 do
    context '#login' do

      before :context do
        @user = create :user, :with_company, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
      end

      context 'POST' do
        it 'logs a user in the app' do
          post '/api/v1/auth/login', %Q{email=#{@user.email}&password=super_password}
          expect(response.status).to eq 201
          expect(JSON.parse(response.body)["access_token"]).not_to be_nil
        end

        it 'should save a reset_token  and send a email' do
          post '/api/v1/auth/forgot_password', %Q{email=#{@user.email}}
          expect(response.status).to eq 201
          expect(@user.reload.reset_token).not_to be_nil
          expect(JSON.parse(response.body)["access_token"]).not_to be_nil
        end

         it 'should reset the password a reset_token  and send a email' do
          post '/api/v1/auth/change_password', %Q{email=#{@user.email}&password=another_super_password&password_confirmation=another_super_password}
          expect(response.status).to eq 201
          expect(@user.reload.authenticate('another_super_password')).to  be_kind_of  User
          expect(JSON.parse(response.body)["access_token"]).not_to be_nil
        end

      end

      context 'GET' do
        before :each do
          UserResetPassword.new(@user).process!
          @token = ActionMailer::Base.deliveries.last.body.to_s.split('token=').last.split('&').first.to_s.strip
        end
        it 'should save a reset_token  and send a email' do
          get '/api/v1/auth/confirmation', %Q{email=#{@user.email}&token=#{@token}}
          expect(response.status).to eq 200
          expect(@user.reload.reset_token).not_to be_nil
          expect(JSON.parse(response.body)["access_token"]).not_to be_nil
        end
      end

    end
  end
end