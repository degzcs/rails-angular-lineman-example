require 'spec_helper'

describe Royalty::DrawPdf do
  let(:seller) do
    create(:user, :with_company, :with_trader_role).company.legal_representative
  end

  let(:buyer) do
    create(:user, :with_company, :with_trader_role).company.legal_representative
  end

  subject(:service) { Royalty::Report.new }

  context 'for one destination' do
    context 'for period 1' do
      before :each do
        gold_batches = 3.times.map { |i| create(:gold_batch, fine_grams: i+1) } # NOTE: gold baches with 1, 2, 3 fine grams
        payment_date = '02-02-2016'.to_date
        orders = gold_batches.each_with_index.map do |gold_batch, i|
          create(:order,
            seller: seller,
            buyer: buyer,
            transaction_state: 'completed',
            gold_batch: gold_batch,
            payment_date: payment_date + i,
            price: 10_000
          )
        end
      end
      it 'should create a royalty report' do
        expected_response = {
          mineral_type: 'ORO',
          fine_grams: 6.0,
          unit: 'gramos',
          base_liquidation_price: 88.875,
          royalty_percentage: 4,
          total: 21.33,
          period: 1,
          year: "01/01/2016".to_date.strftime("%y"), # ex. 16
          company: seller.company,
          mineral_presentation: 'Amalgama',
          destinations: [buyer.company],
        }
        service.call(
          current_user: seller,
          period: expected_response[:period],
          selected_year: '2016',
          mineral_presentation: expected_response[:mineral_presentation],
          base_liquidation_price: expected_response[:base_liquidation_price],
          royalty_percentage: expected_response[:royalty_percentage]
        )

        expected_response.each do |key, value|
          expect(service.__send__(key)).to eq value
        end
      end
    end

    context 'for period 2' do
      before :each do
        gold_batches = 3.times.map { |i| create(:gold_batch, fine_grams: i+1) } # NOTE: gold baches with 1, 2, 3 fine grams
        payment_date = '05-05-2016'.to_date
        orders = gold_batches.each_with_index.map do |gold_batch, i|
          create(:order,
            seller: seller,
            buyer: buyer,
            transaction_state: 'completed',
            gold_batch: gold_batch,
            payment_date: payment_date + i,
            price: 10_000
          )
        end
      end
      it 'should create a royalty report' do
        expected_response = {
          mineral_type: 'ORO',
          fine_grams: 6.0,
          unit: 'gramos',
          base_liquidation_price: 88.875,
          royalty_percentage: 4,
          total: 21.33,
          period: 2,
          year: Time.now.strftime("%y"), # ex. 16
          company: seller.company,
          mineral_presentation: 'Amalgama',
          destinations: [buyer.company],
        }
        service.call(
          current_user: seller,
          period: expected_response[:period],
          selected_year: '2016',
          mineral_presentation: expected_response[:mineral_presentation],
          base_liquidation_price: expected_response[:base_liquidation_price],
          royalty_percentage: expected_response[:royalty_percentage]
        )

        expected_response.each do |key, value|
          expect(service.__send__(key)).to eq value
        end
      end
    end

    context 'for period 3' do
      before :each do
        gold_batches = 3.times.map { |i| create(:gold_batch, fine_grams: i+1) } # NOTE: gold baches with 1, 2, 3 fine grams
        payment_date = '08-08-2016'.to_date
        orders = gold_batches.each_with_index.map do |gold_batch, i|
          create(:order,
            seller: seller,
            buyer: buyer,
            transaction_state: 'completed',
            gold_batch: gold_batch,
            payment_date: payment_date + i,
            price: 10_000
          )
        end
      end
      it 'should create a royalty report' do
        expected_response = {
          mineral_type: 'ORO',
          fine_grams: 6.0,
          unit: 'gramos',
          base_liquidation_price: 88.875,
          royalty_percentage: 4,
          total: 21.33,
          period: 3,
          year: Time.now.strftime("%y"), # ex. 16
          company: seller.company,
          mineral_presentation: 'Amalgama',
          destinations: [buyer.company],
        }
        service.call(
          current_user: seller,
          period: expected_response[:period],
          selected_year: '2016',
          mineral_presentation: expected_response[:mineral_presentation],
          base_liquidation_price: expected_response[:base_liquidation_price],
          royalty_percentage: expected_response[:royalty_percentage]
        )

        expected_response.each do |key, value|
          expect(service.__send__(key)).to eq value
        end
      end
    end

    context 'for period 4' do
      before :each do
        gold_batches = 3.times.map { |i| create(:gold_batch, fine_grams: i+1) } # NOTE: gold baches with 1, 2, 3 fine grams
        payment_date = '11-11-2016'.to_date
        orders = gold_batches.each_with_index.map do |gold_batch, i|
          create(:order,
            seller: seller,
            buyer: buyer,
            transaction_state: 'completed',
            gold_batch: gold_batch,
            payment_date: payment_date + i,
            price: 10_000
          )
        end
      end
      it 'should create a royalty report' do
        expected_response = {
          mineral_type: 'ORO',
          fine_grams: 6.0,
          unit: 'gramos',
          base_liquidation_price: 88.875,
          royalty_percentage: 4,
          total: 21.33,
          period: 4,
          year: Time.now.strftime("%y"), # ex. 16
          company: seller.company,
          mineral_presentation: 'Amalgama',
          destinations: [buyer.company],
        }
        service.call(
          current_user: seller,
          period: expected_response[:period],
          selected_year: '2016',
          mineral_presentation: expected_response[:mineral_presentation],
          base_liquidation_price: expected_response[:base_liquidation_price],
          royalty_percentage: expected_response[:royalty_percentage]
        )

        expected_response.each do |key, value|
          expect(service.__send__(key)).to eq value
        end
      end
    end
  end
end