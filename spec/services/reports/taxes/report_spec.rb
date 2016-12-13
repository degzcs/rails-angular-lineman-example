require 'spec_helper'

describe Reports::Taxes::Report do
  let(:seller) do
    create(:user, :with_company, :with_trader_role).company.legal_representative
  end

  let(:buyer) do
    create(:user, :with_company, :with_trader_role).company.legal_representative
  end

  subject(:service) { Reports::Taxes::Report.new }

  context 'When generate a Taxes Report' do
    before do
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
      seller.setting.regime_type = 'RC'
      buyer.setting.regime_type = 'GC'
    end
    let(:sale_order) { create(:sale, :with_batches, seller: seller, buyer: buyer) }
    
    xit '#call' do
      
    end

    it '#create_report' do
      
    end
  end
end
