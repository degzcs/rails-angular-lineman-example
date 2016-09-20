describe 'Credit Billing', :type => :request do
  describe :v1 do
    context 'natural person' do
      before :context do
        @user = create(:user, :with_profile, :with_personal_rucom)
        @token = @user.create_token
      end

      context 'POST' do
        context 'with company info' do
          it 'returns a representation of the new credit billing created and code 201' do
            per_unit_value = Settings.instance.fine_gram_value
            new_values = {
              user_id: @user.id,
              unit: 200
            }

            expected_response = {
              unit: 200,
              per_unit_value: per_unit_value,
              iva_value: 200 * per_unit_value * 0.16,
              discount: 0.0,
              total_amount: 200 * per_unit_value,
              payment_flag: false,
              payment_date: nil,
              discount_percentage: 0.0
            }

            post '/api/v1/credit_billings', { credit_billing: new_values }, { 'Authorization' => "Barer #{ @token }" }

            expect(response.status).to eq 201
            expect(JSON.parse(response.body)).to match(expected_response.stringify_keys)
          end
        end
      end
    end

    context 'company worker' do
      before :context do
        @user = create(:user, :with_profile, :with_company)
        @token = @user.create_token
      end

      context 'POST' do
        context 'with company info' do
          it 'returns a representation of the new credit billing created and code 201' do
            per_unit_value = Settings.instance.fine_gram_value
            new_values = {
              user_id: @user.id,
              unit: 200
            }

            expected_response = {
              unit: 200,
              per_unit_value: per_unit_value,
              iva_value: 200 * per_unit_value * 0.16,
              discount: 0.0,
              total_amount: 200 * per_unit_value,
              payment_flag: false,
              payment_date: nil,
              discount_percentage: 0.0
            }

            post '/api/v1/credit_billings', {credit_billing: new_values}, { "Authorization" => "Barer #{@token}" }

            expect(response.status).to eq 400
            expect(JSON.parse(response.body)['error']).to match 'Este usuario no esta autorizado para comprar creditos'
          end
        end
      end
    end

    context 'legal representative' do
      before :context do
        @user = create(:company).legal_representative
        @token = @user.create_token
        create_list(:credit_billing, 20, user_id: @user.id)
      end
      context 'GET' do
        it 'verifies that response has the elements number specified in per_page param' do
          per_page = 5
          get '/api/v1/credit_billings', { per_page: per_page } , { "Authorization" => "Barer #{@token}" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).count).to be per_page
        end

        context '/:id' do
          it 'gets a credit billing by id' do
            credit_billing = CreditBilling.last

            expected_response = {
              unit: credit_billing.unit,
              per_unit_value: credit_billing.per_unit_value,
              iva_value: credit_billing.iva_value,
              discount: credit_billing.discount,
              total_amount: credit_billing.total_amount,
              payment_flag: credit_billing.payment_flag,
              # payment_date: credit_billing.payment_date,
              discount_percentage: credit_billing.discount_percentage,
            }

            get "/api/v1/credit_billings/#{credit_billing.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).except('payment_date')).to match expected_response.stringify_keys
          end
        end
      end

      context 'POST' do
        context 'with company info' do
          it 'returns a representation of the new credit billing created and code 201' do
            per_unit_value = Settings.instance.fine_gram_value
            new_values = {
              user_id: @user.id,
              unit: 200
            }

            expected_response = {
              unit: 200,
              per_unit_value: per_unit_value,
              iva_value: 200 * per_unit_value * 0.16,
              discount: 0.0,
              total_amount: 200 * per_unit_value,
              payment_flag: false,
              payment_date: nil,
              discount_percentage: 0.0
            }

            post '/api/v1/credit_billings', {credit_billing: new_values}, { "Authorization" => "Barer #{@token}" }

            expect(response.status).to eq 201
            expect(JSON.parse(response.body)).to match(expected_response.stringify_keys)
          end
        end
      end
    end
  end
end
