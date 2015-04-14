describe 'Purchase', :type => :request do

  describe :v1 do
    context '#purchases' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
         file_path = "#{Rails.root}/spec/support/test_images/image.png"
        seller_picture_path = "#{Rails.root}/spec/support/test_images/seller_picture.png"
        file =  Rack::Test::UploadedFile.new(file_path, "image/jpeg")
        seller_picture =  Rack::Test::UploadedFile.new(seller_picture_path, "image/jpeg")
        @files = [file, seller_picture]
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
           "seller_picture" => {'url' => "#{Rails.root}/spec/uploads/purchase/seller_picture/1/seller_picture.png"},
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
           "files" => @files,
           "origin_certificate_sequence"=>"123456789",
          }
          post '/api/v1/purchases/', {gold_batch: new_gold_batch_values, purchase: new_values},{ "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 201
          expect(JSON.parse(response.body)).to include expected_response
        end
      end
      context "GET" do
        before(:all) do
          provider = create(:provider)
          create_list(:purchase, 20, user_id: @user.id, provider_id: provider.id)
        end
        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/purchases', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end
      end
    end
  end
end