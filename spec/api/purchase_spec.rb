describe 'Purchase', :type => :request do

  describe :v1 do
    context '#purchases' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
         file_path = "#{Rails.root}/spec/support/test_images/image.png"
        @file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")
      end

      context 'POST' do
        it 'should create one complete purchase even its origin cetificate file' do
          expected_response = {
           "id"=>1,
           "user_id"=>1,
           "provider_id"=>1,
           "gold_batch_id" => 1,
           "price" => 1.5,
           "origin_certificate_file" => {'url' => "#{Rails.root}/spec/uploads/purchase/origin_certificate_file/1/image.png"},
           "origin_certificate_sequence"=>"123456789",
          }

          new_gold_batch_values = {
            "id" => 1,
            "parent_batches" => "",
            "grams" => 1.5,
            "grade" => 1,
            "inventory_id" => 1,
          }

          new_values ={
           "id"=>1,
           "user_id"=>1,
           "provider_id"=>1,
           "gold_batch_id" => new_gold_batch_values["id"],
           "price" => 1.5,
           "origin_certificate_file" => @file,
           "origin_certificate_sequence"=>"123456789",
          }
          post '/api/v1/purchases/', {gold_batch: new_gold_batch_values, purchase: new_values},{ "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 201
          expect(JSON.parse(response.body)).to include expected_response
        end
      end
    end
  end
end