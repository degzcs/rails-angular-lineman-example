require 'spec_helper'

describe Purchase::PdfGeneration do
  let(:buyer) { create :user, :with_company }
  let(:gold_batch) { create(:gold_batch, fine_grams: 10, grade: 999, extra_info: { grams: 10 }) }
  let(:purchase_order) { create :purchase, buyer: buyer, gold_batch: gold_batch, performer: buyer }
  let(:service) { Purchase::PdfGeneration.new }

  context 'check process' do
    before :each do
      signature_picture_path = "#{Rails.root}/spec/support/images/signature.png"
      @signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
    end

    it 'should to create a pdf file with the correct information' do
      response = service.call(purchase_order: purchase_order,
                              signature_picture: @signature_picture,
                              draw_pdf_service: ::Purchase::ProofOfPurchase::DrawPDF,
                              document_type: 'equivalent_document')
      expect(response[:success]).to be true
      # TODO: update this when it is made a invoice instead equiv_doc.
      expect(purchase_order.reload.proof_of_purchase.file.path).to match(/equivalent_document.pdf/)
    end

    it 'raise an error when the order of purchase param is empty' do
      expect do
        service.call(purchase_order: nil, draw_pdf_service: nil, document_type: nil)
      end.to raise_error 'You must to provide a purchase_order param'
    end

    it 'raise an error when the draw_pdf_service param is empty' do
      expect do
        service.call(purchase_order: 'something_here', draw_pdf_service: nil, document_type: nil)
      end.to raise_error 'You must to provide a draw_pdf_service param'
    end

    it 'raise an error when the document_type param is empty' do
      expect do
        service.call(purchase_order: 'something_here', draw_pdf_service: 'something_here', document_type: nil)
      end.to raise_error 'You must to provide a document_type param'
    end
  end
end
