describe 'Purchase', :type => :request do

  describe :v1 do
    context '#purchases' do

      before :context do
        @user = create :user, :with_company
        legal_representative = @user.company.legal_representative
        legal_representative.update_column :available_credits, 20000
        @token = @user.create_token
        file_path = "#{ Rails.root }/spec/support/images/image.png"
        seller_picture_path = "#{ Rails.root }/spec/support/images/seller_picture.png"
        file = Rack::Test::UploadedFile.new(file_path, "image/jpeg")
        seller_picture =  Rack::Test::UploadedFile.new(seller_picture_path, "image/jpeg")
        @files = [file, seller_picture]
      end

      context 'POST' do
        it 'should create one complete purchase with its all attached files' do
          provider = create(:external_user)
          expected_response = {
           "id"=>1,
           "user_id"=>@user.company.legal_representative.id,
           "provider"=>{
              "id"=> provider.id,
              "first_name"=> provider.first_name,
              "last_name" => provider.last_name
           },
           "price" => 1.5,
           "origin_certificate_file" => {'url' => "/uploads/documents/purchase/origin_certificate_file/1/image.png"},
           "seller_picture" => {'url' => "/uploads/photos/purchase/seller_picture/1/seller_picture.png"},
           "origin_certificate_sequence"=>"123456789",
           "gold_batch"=> {
              "id"=>1,
              "grams"=>1.5,
              "grade"=>1
           },
           "inventory" => {
              "id"=> 1,
              "status" => true,
              "remaining_amount" => 1.5
           },
           # "created_at"=> '',
           # "barcode_html" => '',
           # "code" => '',
           # "access_token" =>'',
           "trazoro" => false,
           # "sale_id" => nil
          }

          new_gold_batch_values = {
            "id" => 1,
            # "parent_batches" => "",
            "fine_grams" => 1.5,
            "grade" => 1,
            "inventory_id" => 1,
            "extra_info" => { 'grams' => 1.5 }.to_json
          }

          new_purchase_values ={
           "id"=>1,
           "user_id"=>@user.id,
           "provider_id"=>provider.id,
           "gold_batch_id" => new_gold_batch_values["id"],
           "price" => 1.5,
           "files" => @files,
           "origin_certificate_sequence"=>"123456789",
          }
          post '/api/v1/purchases/',
            {
              gold_batch: new_gold_batch_values,
              purchase: new_purchase_values
            },
            {
              "Authorization" => "Barer #{@token}"
            }
          expect(response.status).to eq 201
          expected_response.each do |key, value|
            expect(JSON.parse(response.body)[key]).to eq value
          end
        end
      end

      context "GET" do

        before(:all) do
          provider = create(:external_user)
          create_list(:purchase, 20, :with_proof_of_purchase_file, user_id: @user.id, provider_id: provider.id)
        end

        context "/" do
          context "without purchase_list param" do
            it 'verifies that response has the elements number specified in per_page param' do
              per_page = 5
              get '/api/v1/purchases', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
              expect(response.status).to eq 200
              expect(JSON.parse(response.body).count).to eq per_page
            end
          end

          context "whit purchase_list param" do
            it 'verifies that response has the elements number specified in per_page param' do
              id_list = [1,2,3,4,5,6,7,8]
              get '/api/v1/purchases', { purchase_list: id_list } , { "Authorization" => "Barer #{@token}" }
              expect(response.status).to eq 200
              expect(JSON.parse(response.body).count).to eq 8
            end
          end
        end

        context '/:id' do
          it 'gets purchase by id' do
            purchase = Purchase.last

            expected_response = {
              id: purchase.id,
              price: purchase.price,
            }

            get "/api/v1/purchases/#{purchase.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end
      end
    end
  end
end