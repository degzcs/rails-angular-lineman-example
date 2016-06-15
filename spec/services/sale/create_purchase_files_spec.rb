require 'spec_helper'

describe Sale::CreatePurchaseFilesCollection do
  let(:service){ Sale::CreatePurchaseFilesCollection.new }
  let(:sale) { create(:sale, :with_batches) }

  context 'PDFs' do
    it 'should create both the sale billing and the collection of all origin certifacate' do
      timestamp = Time.now.to_i
      service.call(sale: sale, timestamp: timestamp)
      expect(service.response[:success]).to be true
      expect(sale.purchase_files_collection.file.path).to match(/purchase-files-#{timestamp}.pdf/)
    end
  end
end
