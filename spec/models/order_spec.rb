# == Schema Information
#
# Table name: orders
#
#  id                   :integer          not null, primary key
#  buyer_id             :integer
#  seller_id            :integer
#  courier_id           :integer
#  type                 :string(255)
#  code                 :string(255)
#  price                :float
#  seller_picture       :string(255)
#  trazoro              :boolean          default(FALSE), not null
#  created_at           :datetime
#  updated_at           :datetime
#  transaction_state    :string(255)
#  alegra_id            :integer
#  invoiced             :boolean          default(FALSE)
#  payment_date         :datetime
#  transaction_sequence :integer
#

require 'spec_helper'

RSpec.describe Order, type: :model do
  context 'Micromachine' do
    let(:seller) { create(:user, :with_profile, :with_personal_rucom, :with_authorized_provider_role, provider_type: 'Barequero') }
    let(:gold_batch) { create :gold_batch, fine_grams: 30 }
    let(:purchase) { create :purchase, seller: seller, gold_batch: gold_batch }

    states = {
      initialized: 'initialized',
      paid: 'paid',
      failed: 'failed',
      dispatched: 'dispatched',
      approved: 'approved',
      canceled: 'canceled',
      published: 'published',
      unpublished: 'unpublished'
    }

    it '#save_with_sequence' do
      current_user = purchase.buyer
      purchase.save_with_sequence(current_user)
      expect(purchase.transaction_sequence).to be 1
      expect(current_user.setting.last_transaction_sequence).to be 1
    end

    it '#buyer?' do
      current_user = purchase.buyer
      expect(purchase.buyer?(current_user)).to be_truthy

      current_user = purchase.seller
      expect(purchase.buyer?(current_user)).to be_falsey
    end

    it '#seller?' do
      current_user = purchase.seller
      expect(purchase.seller?(current_user)).to be_truthy

      current_user = purchase.buyer
      expect(purchase.seller?(current_user)).to be_falsey
    end

    context 'purchase' do
      let(:current_user) { purchase.buyer }

      it 'has all the order states required to handle purchase and sale transactions' do
        expect(purchase.status.states.count).to eq(states.count)
        purchase.status.states.each do |state|
          expect(state).to eq(states[state.to_sym])
        end
      end

      it 'sets as initial state the \'initialized\' value in transaction_state field' do
        expect(purchase.transaction_state).to eq('initialized')
      end

      context 'When seller is an authorized provider' do
        it 'sets as paid value the transaction_state field to finish the purchase' do
          purchase.end_transaction!(current_user)
          expect(purchase.status.state).to eq('paid')

          purchase.save
          expect(purchase.transaction_state).to eq('paid')
          expect(purchase.paid?).to eq(true)
        end
        context 'When trigger an event different to end_transaction or crash to purchases transaction' do
          it 'raises an exception and has not changes' do
            message = 'Este usuario no es el vendedor, no está autizado para cambiar el estado de la orden'
            expect { purchase.send_info!(@current_user, '127.0.0.1') }.to raise_error message
            expect(purchase.status.state).to eq('initialized')
            expect(purchase.dispatched?).to be false

            expect { purchase.agree!(current_user, '127.0.0.1') }.to raise_error "Event 'agree' not valid from state 'initialized'"
            expect(purchase.status.state).to eq('initialized')
            expect(purchase.approved?).not_to eq(true)

            expect {purchase.cancel!(current_user, '127.0.0.1')}.to raise_error "Event 'cancel' not valid from state 'initialized'"
            expect(purchase.status.state).to eq('initialized')
            expect(purchase.not_approved?).not_to eq(true)

            purchase.save
            expect(purchase.transaction_state).to eq('initialized')
          end
        end
      end
    end

    context 'sale' do
      before(:all) do
        @current_user = create :user, :with_profile, :with_company, :with_trader_role
        @token = @current_user.create_token
        @legal_representative = @current_user.company.legal_representative
        ## NOTE: Config legal representative (seller) as alegre user and add buyer as alegra contact
        ## This is what contact synchronize do.
        @legal_representative.update_column(:email, 'ejemploapi@dayrep.com')
        @legal_representative.profile.setting.update_column(:alegra_token, '066b3ab09e72d4548e88')
        @buyer = create(:user, :with_company, :with_trader_role).company.legal_representative
        @sales = create_list(:sale, 2, :with_purchase_files_collection_file, :with_proof_of_sale_file, :with_shipment_file, :with_batches, seller: @legal_representative, buyer: @buyer)
        @legal_representative.contact_infos.create(contact: @buyer, contact_alegra_id: 1)
      end

      let(:sale) { @sales.last}

      context 'When the current user not is the seller' do
        context 'when the current user not is the buyer' do
          it 'raises an error ' do
            message = 'Este usuario no es el comprador, no está autizado para cambiar el estado de la orden'
            expect{ sale.send_info!(@current_user, '127.0.0.1') }.to raise_error 'Este usuario no es el vendedor, no está autizado para cambiar el estado de la orden'
            expect{ sale.agree!(@current_user) }.to raise_error message
            expect{ sale.cancel!(@current_user) }.to raise_error message
            expect { sale.end_transaction!(@current_user) }.to raise_error 'Este usuario no está autorizado para finalizar la transacción'

            expect(sale.initialized?).to be true
            expect(sale.dispatched?).to be false
            expect(sale.approved?).to be false
            expect(sale.paid?).to be false
            expect(sale.failed?).to be false
          end

          context 'When trigger end_transaction transition' do
            context 'When the current user not is the legal representative' do
              it 'raises an exception' do
                message = 'Este usuario no está autorizado para finalizar la transacción'
                expect { sale.end_transaction!(@current_user) }.to raise_error message
              end
            end
          end
        end
      end

      context 'When the current user not is a legal representative' do
        it 'should dosen\'t change the sale state and return nil' do
          message = 'Este usuario no es el vendedor, no está autizado para cambiar el estado de la orden'
          expect { sale.send_info!(@current_user)}.to raise_error message
          expect(sale.status.state).to eq('initialized')

          expect(sale.transaction_state).to eq('initialized')
          expect(sale.dispatched?).to be false
        end
      end

      context 'when current user is the legal representative' do
        context 'And he is the seller' do
          let(:current_user_as_seller) do
            sale.seller.roles  = [ Role.find_by(name: 'trader') ]
            sale.seller.save
            sale.seller
          end
          context 'And not is the seller or not is a trader or the the transaction state not is  approved or failed' do
            it 'raises an error' do
              message = 'Verifique que el usuario puede terminar la transacción y que la transacción esté en estado aprobado o fallido'
              expect { sale.end_transaction!(current_user_as_seller) }.to raise_error message
            end
          end

          it 'has all the order states required to handle purchase and sale transactions' do
            expect(sale.status.states).to eq(states.keys.map(&:to_s))
          end

          it 'sets as initialized state the \'initialized\' value in transaction_state field' do
            expect(sale.transaction_state).to eq('initialized')
          end

          it 'sets as dispatched value in transaction_state field' do
            VCR.use_cassette('trazoro_mandrill_send_order_dispathed_template') do
              sale.send_info!(current_user_as_seller)
              expect(sale.status.state).to eq('dispatched')

              expect(sale.transaction_state).to eq('dispatched')
              expect(sale.dispatched?).to eq(true)
            end
          end

          it 'sets as paid value in transaction_state field' do
            sale.crash! #currently the sale is dispatched , failed allows to change to whatever state
            sale.end_transaction!(current_user_as_seller)
            expect(sale.status.state).to eq('paid')

            expect(sale.transaction_state).to eq('paid')
            expect(sale.paid?).to eq(true)
          end
        end

        context 'And he is the buyer' do
          let(:sale) { @sales.first}
          let(:current_user_as_buyer) do
           sale.buyer.roles  = [ Role.find_by(name: 'trader') ]
           sale.buyer.save
           sale.buyer
           end

          it 'sets as failed value in transaction_state field' do
            sale.crash!
            expect(sale.status.state).to eq('failed')

            expect(sale.transaction_state).to eq('failed')
            expect(sale.failed?).to eq(true)
          end

          it 'sets as canceled value in transaction_state field' do
            VCR.use_cassette('trazoro_mandrill_send_order_canceled_template') do
              sale.crash!
              sale.cancel!(current_user_as_buyer)
              expect(sale.status.state).to eq('canceled')

              expect(sale.transaction_state).to eq('canceled')
              expect(sale.not_approved?).to eq(true)
            end
          end

          it 'sets as approved value in transaction_state field' do
            VCR.use_cassette('alegra_create_traders_invoice_for_state_machine') do
              @current_user_as_seller = sale.seller
              sale.crash!
              sale.send_info!(@current_user_as_seller)
              sale.agree!(current_user_as_buyer)
              expect(sale.status.state).to eq('approved')
              expect(sale.transaction_state).to eq('approved')
              expect(sale.approved?).to eq(true)

              expect(sale.invoiced).to eq true
              expect(sale.alegra_id.present?).to eq true
              expect(sale.payment_date.to_date).to eq Time.now.utc.to_date
            end
          end
        end
      end
    end
  end
end
