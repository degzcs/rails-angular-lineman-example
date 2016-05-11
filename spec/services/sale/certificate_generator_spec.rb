require 'spec_helper'

describe  Sale::CertificateGenerator do
  let(:service){ Sale::CertificateGenerator.new }
  let(:purchase){ create(:purchase) }
  let(:seller) { create(:user) }
  let(:external_user) {create(:external_user)}
  let(:sale) {create(:sale, :with_batches, user: seller, client: external_user)}

  context 'PDFs' do
    it 'should create both the sale billing and the collection of all origin certifacate' do
      timestamp = Time.now.to_i
      service.call(sale: sale, timestamp: timestamp)
      expect(sale.origin_certificate_file.filename).to eq "certificate-#{timestamp}.pdf"
    end
  end
end