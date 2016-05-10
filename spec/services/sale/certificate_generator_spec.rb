require 'spec_helper'

describe  Sale::CertificateGenerator do
  let(:service){ Sale::CertificateGenerator.new }
  let(:purchase){ create(:purchase) }
  let(:sale){ create(:sale) }

  context 'PDFs' do
    it 'should create both the sale billing and the collection of all origin certifacate' do
      service.call(sale: sale)
      expect(sale.origin_certificate_file).not_to be empty
    end
  end
end