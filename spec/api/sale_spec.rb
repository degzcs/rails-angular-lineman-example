describe 'Sale', type: :request do
  describe :v1 do
    context '#sales' do
      before :context do
        # NOTE: because this user has a company he not necessarily
        # will be the seller, actually, the seller will be the legal_representative
        @current_user = create :user, :with_profile, :with_company, :with_trader_role
        @token = @current_user.create_token
      end

      context 'POST' do
        it 'should create one complete sale with trader role (this is the first stage in the trader sale process)' do
          VCR.use_cassette('create_complete_sale_from_endpoint') do
            current_buyer = create(:user, :with_profile, :with_company, :with_trader_role).company.legal_representative
            current_seller = @current_user.company.legal_representative
            current_seller.roles = [Role.find_by(name: 'trader')]
            current_seller.save
            @token_seller = current_seller.create_token
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
                'last_name' => current_buyer.profile.last_name,
                'document_number' => current_buyer.profile.document_number,
                'phone_number' => current_buyer.profile.phone_number,
                'address' => current_buyer.profile.address,
                'email' => current_buyer.email
              },
              'user_id' => current_seller.id, # TODO: upgrade frontend
              # 'gold_batch_id' => GoldBatch.last.id + 1,
              'fine_grams' => 1.5,
              # 'performer_id' => current_buyer.id
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
            }, 'Authorization' => "barcode_htmler #{@token_seller}"

            expect(response.status).to eq 201
            expect(JSON.parse(response.body)).to include expected_response

            # Validate Sale audit actions on Orders
            order = Order.first
            expect(order.audits.count).to eq(3) # because it makes 2 actions (create and update)
            expect(order.audits.first.action).to eq('create')
            expect(order.audits.first.audited_changes['type']).to eq('sale')
            expect(order.audits.first.user).to eq(current_seller)
            expect(order.audits.last.action).to eq('update')
            expect(order.shipment.file.path).to match('shipment.pdf')
            # expect(order.audits.last.user).to eq(current_seller) is pending to add the audit_as
          end
        end
      end

      context 'GET' do
        before(:all) do
          @current_user = create :user, :with_profile, :with_company, :with_trader_role
          @token = @current_user.create_token
          @legal_representative = @current_user.company.legal_representative
          @sales = create_list(:sale, 20, :with_purchase_files_collection_file, :with_proof_of_sale_file, :with_shipment_file, seller: @legal_representative)
          @buyer = create(:user, :with_company, :with_trader_role)
        end

        context '/' do
          it 'verifies that response has the elements number specified in per_page param' do
            legal_representative_token = @legal_representative.create_token
            per_page = 5
            get '/api/v1/sales', { per_page: per_page }, 'Authorization' => "Barer #{legal_representative_token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to eq per_page
          end

          it 'should verifies that the elements are corrects in the configuration of entities sale' do
            legal_representative_token = @legal_representative.create_token
            per_page = 3
            get '/api/v1/sales', { per_page: per_page }, 'Authorization' => "Barer #{legal_representative_token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to eq per_page
          end

          it 'verifies that response has the elements number specified in per_page param when is a buyer(office)' do
            per_page = 0
            get '/api/v1/sales', { per_page: per_page }, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to eq per_page
          end
        end

        context '/:id' do
          it 'gets sale by id with role trader' do
            sale = @sales.last

            expected_buyer = {
              'id' => sale.buyer.id,
              'first_name' => sale.buyer.profile.first_name,
              'last_name' => sale.buyer.profile.last_name,
              'document_number' => sale.buyer.profile.document_number,
              'phone_number' => sale.buyer.profile.phone_number,
              'address' => sale.buyer.profile.address,
              'email' => sale.buyer.email
            }

            expected_seller = {
              'id' => sale.seller.id,
              'first_name' => sale.seller.profile.first_name,
              'last_name' => sale.seller.profile.last_name,
              'document_number' => sale.seller.profile.document_number,
              'phone_number' => sale.seller.profile.phone_number,
              'address' => sale.seller.profile.address,
              'email' => sale.seller.email
            }

            expected_response = {
              'id' => sale.id,
              'courier_id' => sale.courier_id,
              'associated_purchases' => [],
              # 'buyer' => buyer_expected_response.stringify_keys,
              'user_id' => @legal_representative.id,
              'gold_batch_id' => sale.gold_batch.id,
              'fine_grams' => sale.fine_grams,
              'mineral_type' => sale.gold_batch.mineral_type,
              'code' => sale.code,
              'barcode_html' => sale.barcode_html,
              'shipment' => sale.shipment.as_json,
              'buyer' => expected_buyer,
              'seller' => expected_seller,
              'price' => sale.price,
              'proof_of_sale' => sale.proof_of_sale.as_json,
              'purchase_files_collection' => sale.purchase_files_collection.as_json,
              'purchases_total_value' => sale.purchases_total_value,
              'total_gain' => sale.total_gain,
              'transaction_state' => sale.transaction_state
            }.deep_reject_keys!('created_at','updated_at')
            get "/api/v1/sales/#{sale.id}", {}, 'Authorization' => "Barer #{@token}"
            expect(response.status).to eq 200
            expect(expected_response).to include JSON.parse(response.body).deep_reject_keys!('created_at','updated_at')
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
              origin_certificate_file: { 'url' => "/test/uploads/documents/document/file/#{@sale.purchase_files_collection.id}/compendio_trazoro.pdf" }
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

        context 'Sale orders pending' do
          context 'CurrentUser as Buyer' do
            before(:all) do
              @current_user = create :user, :with_profile, :with_company, :with_trader_role
              @token = @current_user.create_token
              @current_user_as_seller = create :user, :with_profile, :with_company, :with_trader_role
              @token_to_seller = @current_user_as_seller.create_token
              @legal_representative = @current_user.company.legal_representative
              @sales = create_list(:sale, 20, :with_purchase_files_collection_file, :with_proof_of_sale_file, :with_shipment_file, buyer: @current_user)
              # @buyer = create(:user, :with_company, :with_trader_role)
            end
            context 'by_state' do
              before :each do
                @sale = @sales.last
              end

              it 'gets sales by state' do
                VCR.use_cassette('sale_end_point_gets_sales_by_state') do
                  sale_first = @sales.first
                  current_user_as_seller = sale_first.seller
                  sale_first.send_info!(current_user_as_seller)
                  state = 'dispatched'
                  dispatched_sales = Order.sales_by_state_as_buyer(sale_first.buyer, state)

                  # test  sales_by_state scope
                  expect(dispatched_sales.count).to eq 1

                  get "/api/v1/sales/by_state_buyer/#{state}",{}, 'Authorization' => "Barer #{@token}"
                  expect(response.status).to eq 200

                  res = JSON.parse(response.body)

                  expect(res.count).to eq 1
                  expect(res.first['transaction_state']).to eq state
                end
              end
            end

            context 'when trigger a transition' do
              before :each do
                @current_user_as_buyer = create :user, :with_profile, :with_company, :with_trader_role
                @legal_representative = @current_user_as_buyer.company.legal_representative
                @legal_representative.roles = [ Role.find_by(name: 'trader')]
                @legal_representative.save
                @token_buyer = @legal_representative.create_token
                @sale =  create(:sale, :with_batches, :with_proof_of_sale_file, buyer: @legal_representative) # @sales.last
              end

              it 'sets the transaction field with its respective state' do
                VCR.use_cassette 'sale_order_states_trigger_transitions' do
                  current_user_as_seller = @sale.seller
                  @sale.send_info!(current_user_as_seller)
                  get "/api/v1/sales/#{@sale.id}/transition", {transition: 'cancel!'}, 'Authorization' => "Barer #{@token_buyer}"

                  expect(response.status).to eq 200
                  expect(JSON.parse(response.body)['transaction_state']).to eq 'canceled'

                  @sale.crash!
                  get "/api/v1/sales/#{@sale.id}/transition", {transition: 'agree!'}, 'Authorization' => "Barer #{@token_buyer}"

                  expect(response.status).to eq 200
                  expect(JSON.parse(response.body)['transaction_state']).to eq 'approved'
                end
              end
            end
          end
        end
      end
    end
  end
end
