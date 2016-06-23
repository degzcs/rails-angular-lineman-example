describe 'Sale', :type => :request do

  describe :v1 do
    context '#sales' do

      before :context do
        # NOTE: because this user has a company he not necessarily
        # will be the seller, actually, the seller will be the legal_representative
        @current_user = create :user, :with_company
        @token = @current_user.create_token
      end

      context 'POST' do
        it 'should create one complete sale' do
          buyer = create(:external_user, :with_company)
          seller = @current_user.company.legal_representative
          courier = create(:courier)
          purchases = create_list(:purchase, 2,
                                  :with_proof_of_purchase_file,
                                   user: seller)
          # TODO: change frontend implementation to avoid this.
          selected_purchases = purchases.map{ |purchase| { purchase_id: purchase.id } }

          expected_response = {
            # "id" => 1,
            "courier_id" => courier.id,
            "buyer_id" => buyer.id,
            "user_id" => seller.id, # TODO: upgrade frontend
            # "gold_batch_id" => GoldBatch.last.id + 1,
            "fine_grams" => 1.5,
          }

          new_gold_batch_values = {
            # "id" => expected_response['gold_batch_id'],
            # "parent_batches" => "",
            "fine_grams" => 1.5,
            "grade" => 1,
            # "inventory_id" => 1,
          }

          new_sale_values ={
            # "id"=>1,
            "courier_id"=> courier.id,
            "buyer_id"=> buyer.id,
            # "user_id"=> @current_user.id,
            "price" => 180
            # "gold_batch_id" => expected_response['gold_batch_id']
          }

          post '/api/v1/sales/', {
            gold_batch: new_gold_batch_values,
            sale: new_sale_values,
            selected_purchases: selected_purchases
            },
            {"Authorization" => "Barer #{ @token }"}

          expect(response.status).to eq 201
          expect(JSON.parse(response.body)).to include expected_response
        end
      end

      context "GET" do
        before(:all) do
          @current_user = create :user, :with_company
          @token = @current_user.create_token
          @legal_representative = @current_user.company.legal_representative
          @sales = create_list(:sale, 20, :with_purchase_files_collection_file, :with_proof_of_sale_file, inventory: @legal_representative.inventory)
        end

        context '/' do
          it 'verifies that response has the elements number specified in per_page param' do
            per_page = 5
            get '/api/v1/sales',
              { per_page: per_page } ,
              { "Authorization" => "Barer #{ @token }" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to eq per_page
          end
        end

        context '/:id' do
          it 'gets purchase by id' do
            sale = @sales.last

            expected_response = {
              id:  sale.id,
              courier_id: sale.courier_id,
              buyer_id:  sale.buyer_id,
              user_id: @legal_representative.id,
              gold_batch_id: sale.gold_batch.id,
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
            @sale = @sales.last
          end

          it 'gets purchase by code' do
            ###IMPROVE: this test was created provitionaly in order to convert the user in provider. Have to be refactored!!
            # provider_hash = sale.user.attributes.symbolize_keys.except(:created_at, :updated_at, :password_digest, :reset_token, :document_expedition_date).stringify_keys

            seller_expected_response = {
              id: @legal_representative.id,
              name: "#{@legal_representative.first_name} #{@legal_representative.last_name}",
              company_name: @legal_representative.company.name,
              document_type: 'NIT',
              document_number: @legal_representative.company.nit_number,
              rucom_record:  @legal_representative.company.rucom.rucom_record,
              num_rucom: @legal_representative.company.rucom.num_rucom,
              rucom_status: @legal_representative.company.rucom.status
            }

            expected_response = {
              id:  @sale.id,
              gold_batch_id: @sale.gold_batch.id,
              fine_grams: @sale.fine_grams,
              code: @sale.code,
              provider: seller_expected_response.stringify_keys,
              origin_certificate_file: {"url"=>"/uploads/documents/document/file/#{ @sale.purchase_files_collection.id }/documento_equivalente_de_venta.pdf"}
            }
            # TODO: upgrade Front end with proof_of_sale and purchase_files_collections files

            get "/api/v1/sales/get_by_code/#{ @sale.code }",
              {},
              { "Authorization" => "Barer #{ @token }" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end

        context '/:id/batches' do
          it 'verifies that response has the elements number specified in per_page param' do
            sale = Sale.last
            total_sold_batches = 30
            list = create_list(:sold_batch, total_sold_batches, sale_id: sale.id)

            get "/api/v1/sales/#{ sale.id }/batches",
              {} ,
              { "Authorization" => "Barer #{ @token }" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to be total_sold_batches
          end
        end
      end
    end
  end
end