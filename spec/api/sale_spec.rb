describe 'Sale', :type => :request do

  describe :v1 do
    context '#sales' do

      before :context do
        @user = create :user, :with_company
        @token = @user.create_token
      end

      context 'POST' do
        it 'should create one complete sale' do
          client = create(:external_user, :with_company)
          courier = create(:courier)
          purchases = create_list(:purchase, 2, :with_proof_of_purchase_file, user: @user)
          selected_purchases = purchases.map do |purchase|
            {
              'purchase_id' => purchase.id,
              'amount_picked' => 1
            }
          end

          expected_response = {
            "id"=>1,
            "courier_id"=>1,
            "client_id"=>client.id,
            "user_id"=>@user.id,
            "gold_batch_id"=>3,
            "fine_grams"=>1.5,
          }

          new_gold_batch_values = {
            "id" => 3,
            # "parent_batches" => "",
            "fine_grams" => 1.5,
            "grade" => 1,
            "inventory_id" => 1,
          }

          new_values ={
            "id"=>1,
            "courier_id"=>courier.id,
            "client_id"=>client.id,
            "user_id"=>@user.id,
            "gold_batch_id" => new_gold_batch_values["id"]
          }

          post '/api/v1/sales/', {gold_batch: new_gold_batch_values, sale: new_values, selected_purchases: selected_purchases },{"Authorization" => "Barer #{@token}"}
          expect(response.status).to eq 201
          expect(JSON.parse(response.body)).to include expected_response
        end
      end

      context "GET" do
        before(:all) do
          create_list(:sale, 20, user: User.last)
        end
        context '/' do
          it 'verifies that response has the elements number specified in per_page param' do
            per_page = 5
            get '/api/v1/sales', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to be per_page
          end
        end

        context '/:id' do
          it 'gets purchase by id' do
            sale = Sale.last

            expected_response = {
              id:  sale.id,
              courier_id: sale.courier_id,
              client_id:  sale.client_id,
              user_id: sale.user_id,
              gold_batch_id: sale.gold_batch_id,
              fine_grams: sale.fine_grams,
              code: sale.code,
              barcode_html: sale.barcode_html
            }
            get "/api/v1/sales/#{sale.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end

        context 'get_by_code/:code' do
          before :each do
            @sale = Sale.last
            @sale.user.office.company = create(:company)
            @sale.user.rucom = create(:rucom)
            @sale.user.save
            file_path = "#{Rails.root}/spec/support/pdfs/origin_certificate_file.pdf"
            File.open(file_path){|f|  @sale.origin_certificate_file = f}
            @sale.save
            @sale.reload
          end

          it 'gets purchase by code' do
          ###IMPROVE: this test was created provitionaly in order to convert the user in provider. Have to be refactored!!
            # provider_hash = sale.user.attributes.symbolize_keys.except(:created_at, :updated_at, :password_digest, :reset_token, :document_expedition_date).stringify_keys

          provider_hash = {
            id: @sale.user.id,
            name: "#{@sale.user.first_name} #{@sale.user.last_name}",
            company_name: @sale.user.company.name,
            document_type: 'NIT',
            document_number: @sale.user.company.nit_number,
            rucom_record:  @sale.user.rucom.rucom_record,
            num_rucom: @sale.user.rucom.num_rucom,
            rucom_status: @sale.user.rucom.status
          }

            expected_response = {
              id:  @sale.id,
              gold_batch_id: @sale.gold_batch_id,
              fine_grams: @sale.fine_grams,
              code: @sale.code,
              provider: provider_hash.stringify_keys,
              origin_certificate_file: {"url"=>"/uploads/documents/sale/origin_certificate_file/#{@sale.id}/origin_certificate_file.pdf"}
            }

            get "/api/v1/sales/get_by_code/#{@sale.code}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end

        context '/:id/batches' do
          it 'verifies that response has the elements number specified in per_page param' do
            sale = Sale.last
            total_sold_batches = 30
            list = create_list(:sold_batch, total_sold_batches, sale_id: sale.id)

            get "/api/v1/sales/#{sale.id}/batches", {} , { "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to be total_sold_batches
          end
        end
      end
    end
  end
end