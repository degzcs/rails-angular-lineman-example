describe 'Sale', type: :request do
  describe :v1 do
    context '#sales' do
      before :context do
        # NOTE: because this user has a company he not necessarily
        # will be the seller, actually, the seller will be the legal_representative
        @current_user = create :user, :with_company, :with_trader_role
        @token = @current_user.create_token
      end

      context 'POST' do
        it 'should create one complete sale with trader role' do
          current_buyer = create(:user, :with_company, :with_trader_role).company.legal_representative
          current_seller = @current_user.company.legal_representative
          courier = create(:courier)
          purchases = create_list(:purchase, 2,
                                  :with_origin_certificate_file,
                                  :with_proof_of_purchase_file,
                                  buyer: current_seller)
          # TODO: change frontend implementation to avoid this.
          selected_purchases = purchases.map { |purchase| { id: purchase.id } }
          expected_response = {
            'courier_id' => courier.id,
            'buyer' => {
              'id' => current_buyer.id,
              'first_name' => current_buyer.profile.first_name,
              'last_name' => current_buyer.profile.last_name
            },
            'user_id' => current_seller.id, # TODO: upgrade frontend
            'fine_grams' => 1.5
          }

          new_gold_batch_values = {
            'fine_grams' => 1.5,
            'grade' => 1
          }

          new_sale_values = {
            'courier_id' => courier.id,
            'buyer_id' => current_buyer.id,
            'price' => 180
          }

          post '/api/v1/sales/', {
            gold_batch: new_gold_batch_values,
            sale: new_sale_values,
            selected_purchases: selected_purchases
          }, 'Authorization' => "barcode_htmler #{@token}"

          expect(response.status).to eq 201
          expect(JSON.parse(response.body)).to include expected_response

          # Validate Sale audit actions on Orders
          order = Order.last
          expect(order.audits.count).to eq(2) # because it makes 2 actions (create and update)
          expect(order.audits.first.action).to eq('create')
          expect(order.audits.first.audited_changes['type']).to eq('sale')
          expect(order.audits.first.user).to eq(current_seller)
          expect(order.audits.last.action).to eq('update')
          # expect(order.audits.last.user).to eq(current_seller) is pending to add the audit_as
        end
      end

      context 'GET' do
        before(:all) do
          @current_user = create :user, :with_company, :with_trader_role
          @token = @current_user.create_token
          @legal_representative = @current_user.company.legal_representative
          @sales = create_list(:sale, 20, :with_purchase_files_collection_file, :with_proof_of_sale_file, seller: @legal_representative)
          @buyer = create(:user, :with_company, :with_trader_role)
        end

        context '/' do
          it 'verifies that response has the elements number specified in per_page param' do
            per_page = 5
            get '/api/v1/sales', { per_page: per_page }, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to eq per_page
          end

          it 'should verifies that the elements are corrects in the configuration of entities sale' do
            per_page = 3
            get '/api/v1/sales', { per_page: per_page }, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to eq per_page
          end
        end

        context '/:id' do
          it 'gets purchase by id with role trader' do
            sale = @sales.last

            expected_response = {
              id: sale.id,
              courier_id: sale.courier_id,
              user_id: @legal_representative.id,
              gold_batch_id: sale.gold_batch.id,
              fine_grams: sale.fine_grams,
              code: sale.code,
              barcode_html: sale.barcode_html
            }
            get "/api/v1/sales/#{sale.id}", {}, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end

        context 'get_by_code/:code' do
          before :each do
            @sale = @sales.last
          end

          it 'gets purchase by code' do
            # IMPROVE: this test was created provitionaly in order to convert the user in provider. Have to be refactored!!
            # provider_hash = sale.user.attributes.symbolize_keys.except(:created_at, :updated_at, :password_digest, :reset_token, :document_expedition_date).stringify_keys

            seller_expected_response = {
              id: @legal_representative.id,
              name: "#{@legal_representative.profile.first_name} #{@legal_representative.profile.last_name}",
              company_name: @legal_representative.company.name,
              document_type: 'NIT',
              document_number: @legal_representative.company.nit_number,
              rucom_record:  @legal_representative.company.rucom.rucom_number,
              num_rucom: @legal_representative.company.rucom.rucom_number,
              rucom_status: @legal_representative.company.rucom.status
            }

            expected_response = {
              id:  @sale.id,
              gold_batch_id: @sale.gold_batch.id,
              fine_grams: @sale.fine_grams,
              code: @sale.code,
              provider: seller_expected_response.stringify_keys,
              origin_certificate_file: { 'url' => "/test/uploads/documents/document/file/#{@sale.purchase_files_collection.id}/documento_equivalente_de_venta.pdf" }
            }
            # TODO: upgrade Front end with proof_of_sale and purchase_files_collections files

            get "/api/v1/sales/get_by_code/#{@sale.code}", {}, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end

        context '/:id/batches' do
          it 'verifies that response has the elements number specified in per_page param' do
            order = Order.last
            total_sold_batches = 30
            create_list(:sold_batch, total_sold_batches, order_id: order.id)

            get "/api/v1/sales/#{order.id}/batches", {}, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to be total_sold_batches
          end
        end
      end
    end
  end
end
