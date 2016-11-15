# == Schema Information
#
# Table name: orders
#
#  id                :integer          not null, primary key
#  buyer_id          :integer
#  seller_id         :integer
#  courier_id        :integer
#  type              :string(255)
#  code              :string(255)
#  price             :float
#  seller_picture    :string(255)
#  trazoro           :boolean          default(FALSE), not null
#  created_at        :datetime
#  updated_at        :datetime
#  transaction_state :string(255)
#  alegra_id         :integer
#  invoiced          :boolean          default(FALSE)
#  payment_date      :datetime
#

require 'spec_helper'

RSpec.describe Order, type: :model do
  context 'Micromachine' do
    let(:seller) { create(:user, :with_profile, :with_personal_rucom, provider_type: 'Barequero') }
    let(:gold_batch) { create :gold_batch, fine_grams: 30 }
    let(:purchase) { create :purchase, seller: seller, gold_batch: gold_batch }

    states = {
      initialized: 'initialized',
      paid: 'paid',
      failed: 'failed',
      dispatched: 'dispatched',
      approved: 'approved',
      canceled: 'canceled'
    }

    context 'purchase' do
      it 'has all the order states required to handle purchase and sale transactions' do
        expect(purchase.status.states.count).to eq(states.count)
        purchase.status.states.each do |state|
          expect(state).to eq(states[state.to_sym])
        end
      end

      it 'sets as initial state the \'initialized\' value in transaction_state field' do
        expect(purchase.transaction_state).to eq('initialized')
      end

      it 'sets as paid value in transaction_state field' do
        purchase.end_transaction!
        expect(purchase.status.state).to eq('paid')

        purchase.save
        expect(purchase.transaction_state).to eq('paid')
        expect(purchase.paid?).to eq(true)
      end

      it 'has not changes when trigger an event different to end_transaction or crash to purchases transaction' do
        purchase.send_info!
        expect(purchase.status.state).to eq('initialized')
        expect(purchase.dispatched?).not_to eq(true)

        purchase.agree!
        expect(purchase.status.state).to eq('initialized')
        expect(purchase.approved?).not_to eq(true)

        purchase.cancel!
        expect(purchase.status.state).to eq('initialized')
        expect(purchase.not_approved?).not_to eq(true)

        purchase.save
        expect(purchase.transaction_state).to eq('initialized')
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
        @sales = create_list(:sale, 2, :with_purchase_files_collection_file, :with_proof_of_sale_file, :with_shipment_file, seller: @legal_representative, buyer: @buyer)
        @legal_representative.contact_infos.create(contact: @buyer, contact_alegra_id: 1)
      end

      let(:sale) { @sales.last }

      it 'has all the order states required to handle purchase and sale transactions' do
        expect(sale.status.states).to eq(states.keys.map(&:to_s))
      end

      it 'sets as initialized state the \'initialized\' value in transaction_state field' do
        expect(sale.transaction_state).to eq('initialized')
      end

      it 'sets as dispatched value in transaction_state field' do
        sale.send_info!
        expect(sale.status.state).to eq('dispatched')

        #sale.save
        expect(sale.transaction_state).to eq('dispatched')
        expect(sale.dispatched?).to eq(true)
      end

      it 'sets as canceled value in transaction_state field' do
        sale.cancel!
        expect(sale.status.state).to eq('canceled')

        expect(sale.transaction_state).to eq('canceled')
        expect(sale.not_approved?).to eq(true)
      end

      it 'sets as failed value in transaction_state field' do
        sale.crash!
        expect(sale.status.state).to eq('failed')

        expect(sale.transaction_state).to eq('failed')
        expect(sale.failed?).to eq(true)
      end

      it 'sets as approved value in transaction_state field' do
        VCR.use_cassette('alegra_create_traders_invoice') do
          @sale =  create(:sale, :with_batches, :with_proof_of_sale_file)
          @sale.send_info!
          @sale.agree!
          expect(@sale.status.state).to eq('approved')
          expect(@sale.transaction_state).to eq('approved')
          expect(@sale.approved?).to eq(true)
          
          expect(@sale.invoiced).to eq true
          expect(@sale.alegra_id.present?).to eq true
          expect(@sale.payment_date.to_date).to eq Time.now.to_date
        end
      end

      it 'sets as paid value in transaction_state field' do
        sale.end_transaction!
        expect(sale.status.state).to eq('paid')

        expect(sale.transaction_state).to eq('paid')
        expect(sale.paid?).to eq(true)
      end

      xit 'raises an error when executes a triggers with a not permited transition ' do
        # the last state was paid so it should reject the approved state as shown below
        expect { sale.send_info! }.to raise_error(MicroMachine::InvalidState)
        expect { sale.send_info! }.to raise_error('Event \'send_info\' not valid from state \'paid\'')

        expect { sale.agree! }.to raise_error(MicroMachine::InvalidState)
        expect { sale.agree! }.to raise_error('Event \'agree\' not valid from state \'paid\'')

        expect { sale.cancel! }.to raise_error(MicroMachine::InvalidState)
        expect { sale.cancel! }.to raise_error('Event \'cancel\' not valid from state \'paid\'')
      end

      xit 'has not changes when trigger an event different to end_transaction or crash to sales transaction' do
        sale.send_info!
        expect(sale.status.state).to eq('initialized')
        expect(sale.dispatched?).not_to eq(true)

        sale.agree!
        expect(sale.status.state).to eq('initialized')
        expect(sale.approved?).not_to eq(true)

        sale.cancel!
        expect(sale.status.state).to eq('initialized')
        expect(sale.not_approved?).not_to eq(true)

        #sale.save
        expect(sale.transaction_state).to eq('initialized')
      end
    end
  end
end
