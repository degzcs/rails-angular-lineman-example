describe 'Purchase', type: :request do
  describe :v1 do
    context '#purchases (buyer is not necessary the company legal representative)' do
      before :context do
        @buyer = create :user, :with_profile, :with_company, :with_trader_role
        @legal_representative = @buyer.company.legal_representative
        @legal_representative.profile.update_column :available_credits, 20_000
        @trazoro_service = create(:available_trazoro_service, credits: 1.0, reference: 'buy_gold')
        @legal_representative.setting.trazoro_services << @trazoro_service
        @token = @buyer.create_token
        seller_picture_path = "#{Rails.root}/spec/support/images/seller_picture.png"
        signature_picture_path = "#{Rails.root}/spec/support/images/signature.png"
        seller_picture = Rack::Test::UploadedFile.new(seller_picture_path, 'image/jpeg')
        signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
        # add signature_picture in @files for sending parameters correct
        @files = [seller_picture, signature_picture]

        @new_gold_batch_values = {
          'fine_grams' => 1.5,
          'grade' => 1,
          'extra_info' => { 'grams' => 1.5 }.to_json
        }

        @seller = create(:user, :with_profile, :with_personal_rucom, :with_authorized_provider_role, provider_type: 'barequero')

        @new_purchase_values = {
          'seller_id' => @seller.id,
          'price' => 1.5,
          'files' => @files
        }
      end

      context 'POST' do
        it 'should create one complete purchase with its all attached files' do
          expected_response = {
            'user_id' => @buyer.company.legal_representative.id,
            'seller' => { # TODO: change front end variable name from provider to seller
              'id' => @seller.id,
              'first_name' => @seller.profile.first_name,
              'last_name' => @seller.profile.last_name
            },
            'price' => 1.5,
            'gold_batch' => {
              'grams' => 1.5,
              'grade' => 1
            },
            'trazoro' => false
          }

          expected_files = {
            'seller_picture' => 'seller_picture.png'
          }
          post '/api/v1/purchases/', {
            gold_batch: @new_gold_batch_values,
            purchase: @new_purchase_values
          }, 'Authorization' => "Barer #{@token}"

          expect(response.status).to eq 201
          expected_response.except('gold_batch').each do |key, value|
            expect(JSON.parse(response.body)[key]).to eq value
          end

          expected_response['gold_batch'].each do |key, value|
            expect(JSON.parse(response.body)['gold_batch'][key]).to eq value
          end

          expected_files.each do |key, value|
            expect(JSON.parse(response.body)[key]['url']).to match value
          end

          order = Order.last

          # validate the transaction state after is saved
          expect(order.paid?).to eq(true)

          # Validate purchase audit actions on Orders
          expect(order.audits.count).to eq(1)
          expect(order.audits.last.audited_changes['type']).to eq('purchase')
          expect(order.audits.last.user).to eq(@buyer)
          expect(order.buyer).to eq(@legal_representative)
        end

        it 'POST buy threshold error' do
          # Create a purchase with 30 fine grams for the current seller
          gold_batch = create :gold_batch, fine_grams: 30
          create :purchase, seller: @seller, gold_batch: gold_batch
          seller_name = UserPresenter.new(@seller, self).name

          expected_response = {
            'error' => 'unexpected error',
            'detail' => [
              'Usted no puede realizar esta compra, debido a que con esta compra el barequero exederia' \
              " el limite permitido por mes. El total comprado hasta el momento por #{seller_name} " \
              'es: 30.0 gramos finos'
            ]
          }
          post '/api/v1/purchases/', {
            gold_batch: @new_gold_batch_values,
            purchase: @new_purchase_values
          }, 'Authorization' => "Barer #{@token}"

          expect(response.status).to eq 409
          expect(JSON.parse(response.body)).to eq expected_response
        end
      end

      context 'GET' do
        before(:all) do
          seller = create(:user, :with_profile, :with_personal_rucom, :with_authorized_provider_role)
          @purchases = create_list(:purchase, 20,
                                   :with_proof_of_purchase_file,
                                   :with_origin_certificate_file,
                                   buyer: @buyer.company.legal_representative,
                                   seller_id: seller.id)
        end

        context '/' do
          context 'List all purchases corresponding to the user' do
            it 'verifies that response has the elements number specified in per_page param when  is a buyer(office)' do
              per_page = 0
              get '/api/v1/purchases', { per_page: per_page }, 'Authorization' => "Barer #{@token}"
              expect(response.status).to eq 200
              expect(JSON.parse(response.body).count).to eq per_page
            end

            it 'verifies that response has the elements number specified in per_page param when is a legal_representative' do
              per_page = 5
              legal_representative_token = @legal_representative.create_token
              get '/api/v1/purchases', { per_page: per_page }, 'Authorization' => "Barer #{legal_representative_token}"
              expect(response.status).to eq 200
              expect(JSON.parse(response.body).count).to eq per_page
            end
          end
        end

        context '/:id' do
          it 'gets purchase by id' do
            purchase = Order.where(type: 'purchase').last

            expected_response = {
              id: purchase.id,
              price: purchase.price
            }

            get "/api/v1/purchases/#{purchase.id}", {}, 'Authorization' => "Barer #{@token}"

            expect(response.status).to eq 200
            expect(JSON.parse(response.body)).to include expected_response.stringify_keys
          end
        end

        context '/free_to_sale' do
          it 'verifies that response has the elements number specified in per_page param when not is a legal_representative' do
            per_page = 0
            get '/api/v1/purchases/free_to_sale', { per_page: per_page }, 'Authorization' => "Barer #{@token}"

            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to eq per_page

            # it 'returns all purchases where its gold batch is not sale (sold == false)'
            purchases_free = JSON.parse(response.body).select { |p| p['gold_batch']['sold'] == false }
            expect(purchases_free.count).to eq per_page
          end

          it 'verifies that response has the elements number specified in per_page param when is a legal_representative' do
            legal_representative_token = @legal_representative.create_token
            per_page = 5
            get '/api/v1/purchases/free_to_sale', { per_page: per_page }, 'Authorization' => "Barer #{legal_representative_token}"

            expect(response.status).to eq 200
            expect(JSON.parse(response.body).count).to eq per_page

            # it 'returns all purchases where its gold batch is not sale (sold == false)'
            purchases_free = JSON.parse(response.body).select { |p| p['gold_batch']['sold'] == false }
            expect(purchases_free.count).to eq per_page
          end
        end
      end
    end
  end
end
