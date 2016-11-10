require 'spec_helper'

describe Sale::PurchaseFilesCollection::Generation do
  let(:service){ Sale::PurchaseFilesCollection::Generation.new }
  let(:sale_order) { create(:sale, :with_batches) }

  context 'PDFs' do
    it 'should create both the sale billing and the collection of all origin certifacate' do
      timestamp = Time.now.to_i
      service.call(sale_order: sale_order, timestamp: timestamp)
      expect(service.response[:success]).to be true
      expect(sale_order.purchase_files_collection.file.path).to match(/purchase-files-#{timestamp}.pdf/)
    end
  end
end
