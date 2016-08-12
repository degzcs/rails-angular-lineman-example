require 'spec_helper'

describe Sale::ProofOfSale::GenerationService do
  let(:current_user){ create :user, :with_company }
  let(:gold_batch){ create(:gold_batch, fine_grams: 10, grade: 999, extra_info: { grams: 10 }) }
  let(:sale){ create :sale, user: current_user, gold_batch: gold_batch }
  let(:service){ Sale::ProofOfSale::GenerationService.new }

  context 'check process' do
    it 'should to create a pdf file with the correct information' do
      response = service.call(sale: sale)
      expect(response[:success]).to be true
      expect(sale.reload.proof_of_sale.file.path).to match(/equivalent_document.pdf/)
    end

    it 'raise an error when sale param is empty' do
      expect{ service.call(sale: nil) }.to raise_error 'You must to provide a sale param'
    end
  end
end