require 'spec_helper'

describe Purchase::PdfGeneration do
  let(:buyer){ create :user, :with_company }
  let(:gold_batch){ create(:gold_batch, fine_grams: 10, grade: 999, extra_info: { grams: 10 }) }
  let(:purchase){ create :purchase, user: buyer, gold_batch: gold_batch }
  let(:service){ Purchase::PdfGeneration.new }

  context 'check process' do
    it 'should to create a pdf file with the correct information' do
      response = service.call(
                        purchase: purchase,
                        draw_pdf_service: ::Purchase::ProofOfPurchase::DrawPDF,
                        document_type: 'equivalent_document',
                        )
      expect(response[:success]).to be true
      # TODO: update this when it is made a invoice instead equiv_doc.
      expect(purchase.reload.proof_of_purchase.file.path).to match(/equivalent_document.pdf/)
    end

    it 'raise an error' do
      expect{ service.call(purchase: nil) }.to raise_error
    end
  end
end