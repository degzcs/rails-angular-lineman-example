require 'spec_helper'

describe Reports::Taxes::Report do
  let(:seller) do
    create(:user, :with_company, :with_trader_role).company.legal_representative
  end

  let(:buyer) do
    create(:user, :with_company, :with_trader_role).company.legal_representative
  end

  subject(:service) { Reports::Taxes::Report.new }

  let!(:barequero) { create(:user, :with_profile, :with_personal_rucom, :with_authorized_provider_role) }
  #let(:purchase) { create(:purchase, buyer: seller, seller: buy_seller, price: 1_000_000) }
     
  context 'Purchase' do
    context 'When generate a Purchase Tax Report' do
      context '#call' do
        before do 
          gold_batch = create(:gold_batch, fine_grams: 6.1)
          payment_date = '08-08-2016'.to_date
          @purchase_order = 
            create(:purchase,
              seller: barequero,
              buyer: seller,
              transaction_state: 'paid',
              gold_batch: gold_batch,
              payment_date: payment_date,
              price: 1_000_000
            )
          @purchase_order.buyer.setting.regime_type = 'RC'
        end
        context 'When there is not tax settings' do
          it 'returns a hash with arrays empties in each pair value' do
            repor_expected = {
              movements: [],
              taxes: [],
              payments: []
            }
            response = service.call(order: @purchase_order)
            expect(response).to eq repor_expected
          end
        end
        context 'When there are transaction_movements' do
          it 'returns a hash with an array of OpenStruct objects with its respective structure' do
            system 'rake db:seed:tax_module RAILS_ENV=test'

            repor_expected = {
              :movements => [ OpenStruct.new(
                   :count => "140501",
                    :name => "Materias Primas Oro",
                   :debit => 1000000,
                  :credit => ""
                ),
                OpenStruct.new(
                   :count => "220505",
                    :name => "Proveedores Nacionales",
                   :debit => "",
                  :credit => 765000
                )
              ],
              :taxes => [
                OpenStruct.new(
                   :count => "236740",
                    :name => "IVA retenido en compras (2.4%)",
                   :debit => "",
                  :credit => 190000
                ),
                OpenStruct.new(
                   :count => "236840",
                    :name => "ICA retenido en compras (1% Medellín)",
                   :debit => "",
                  :credit => 10000
                ),
                OpenStruct.new(
                   :count => "236540",
                    :name => "Retención en compras (2.5)",
                   :debit => "",
                  :credit => 35000
               )
              ],
              :payments => [
                 OpenStruct.new(
                   :count => "220505",
                    :name => "Proveedores Nacionales",
                   :debit => 765000,
                  :credit => ""
                ),
                OpenStruct.new(
                   :count => "111005",
                    :name => "Moneda Nacional",
                   :debit => "",
                  :credit => 765000
               )
              ]
            }
            response = service.call(order: @purchase_order)
            expect(response).to eq repor_expected
          end
        end
      end
    end
  end

  context 'Sale' do
    context 'When generate a Taxes Report' do
      before do
        gold_batches = 3.times.map { |i| create(:gold_batch, fine_grams: i+1) } # NOTE: gold baches with 1, 2, 3 fine grams
        payment_date = '08-08-2016'.to_date
        orders = gold_batches.each_with_index.map do |gold_batch, i|
          create(:order,
            seller: seller,
            buyer: buyer,
            transaction_state: 'paid',
            gold_batch: gold_batch,
            payment_date: payment_date + i,
            price: 1_000_000
          )
        end
        seller.setting.regime_type = 'RC'
        buyer.setting.regime_type = 'GC'
      end
      let(:sale_order) { create(:sale, :with_batches, seller: seller, buyer: buyer, price: 4_000_000) }

      context '#call' do
        context 'When there is not tax settings' do
          xit 'returns a hash with arrays empties in each pair value' do
            repor_expected = {
              movements: [],
              taxes: [],
              payments: [],
              inventories: []
            }
            response = service.call(order: sale_order)
            expect(response).to eq repor_expected
          end
        end
        context 'When there are transaction_movements' do
          it 'returns a hash with an array of OpenStruct objects with its respective structure' do
            system 'rake db:seed:tax_module RAILS_ENV=test'

            repor_expected = {
              :movements => [ OpenStruct.new(
                   :count => "130505",
                    :name => "Clientes Nacionales",
                   :debit => 4000000,
                  :credit => ""
                ),
                OpenStruct.new(
                   :count => "413595",
                    :name => "Ingresos por Venta de Oro",
                   :debit => "",
                  :credit => 4000000
                )
              ],
              :taxes => [
               #  OpenStruct.new(
               #     :count => "135595",
               #      :name => "ANTICIPO CREE (.40%)",
               #     :debit => 0,
               #    :credit => ""
               #  ),
               #  OpenStruct.new(
               #     :count => "23657501",
               #      :name => "Autorretención CREE",
               #     :debit => "",
               #    :credit => 0
               # )
              ],
              :payments => [
                 OpenStruct.new(
                   :count => "111005",
                    :name => "Moneda Nacional",
                   :debit => 4000000,
                  :credit => ""
                ),
                OpenStruct.new(
                   :count => "130505",
                    :name => "Clientes Nacionales",
                   :debit => "",
                  :credit => 4000000
               )
              ],
              :inventories => [
                 OpenStruct.new(
                   :count => "613516",
                    :name => "Venta Materias Primas Oro",
                   :debit => 3000000,
                  :credit => ""
                ),
                OpenStruct.new(
                   :count => "140501",
                    :name => "Materias Primas Oro",
                   :debit => "",
                  :credit => 3000000
               )
              ]
            }
            response = service.call(order: sale_order)
            expect(response).to eq repor_expected
          end
        end
      end
    end
  end
end
