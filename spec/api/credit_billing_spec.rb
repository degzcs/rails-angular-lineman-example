describe 'Credit Billing', :type => :request do

  describe :v1 do
    context 'credit_billings' do

      before :context do
        @user = FactoryGirl.create :user, email: 'elcho.esquillas@fake.com', password: 'super_password', password_confirmation: 'super_password'
        @token = @user.create_token
        FactoryGirl.create_list(:credit_billing, 20, user_id: @user.id)
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
              #payment_date: credit_billing.payment_date,
              discount_percentage: credit_billing.discount_percentage,
            }

            get "/api/v1/credit_billings/#{credit_billing.id}",{},{ "Authorization" => "Barer #{@token}" }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).except('payment_date')).to match expected_response.stringify_keys
          end
        end
      end

      context 'POST' do
        context "with company info" do
          it 'returns a representation of the new credit billing created and code 201' do
            
            new_values = {
              user_id: @user.id,
              total_amount: 20000000
            }

            expected_response = {
              unit: 1,
              per_unit_value: 1000.0,
              iva_value: 16.0,
              discount: nil,
              total_amount: 20000000.0,
              payment_flag: false,
              payment_date: nil,
              discount_percentage: nil
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