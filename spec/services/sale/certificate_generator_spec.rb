require 'spec_helper'

describe  Sale::PruchaseFilesGenerator do
  let(:service){ Sale::PruchaseFilesGenerator.new }
  let(:sale) { create(:sale, :with_batches, purchase_files_collection: nil) }

  context 'PDFs' do
    it 'should create both the sale billing and the collection of all origin certifacate' do
      timestamp = Time.now.to_i
      service.call(sale: sale, timestamp: timestamp)
      expect(sale.purchase_files_collection.file.filename).to eq "certificate-#{timestamp}.pdf"
    end
  end
end