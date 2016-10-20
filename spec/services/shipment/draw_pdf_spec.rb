require 'spec_helper'

describe Shipment::DrawPdf do
    let(:seller) {create :user, :with_profile, :with_personal_rucom, :with_authorized_provider_role, provider_type: 'Barequero', first_name: 'nametest', last_name: 'last_nametest', document_number: '1234567890', city: City.find_by(name: 'MEDELLIN')
    }
    let(:courier) { create :courier }
    let(:rucom) { create :rucom, rucom_number: '7767899877' }
    let(:buyer) { create :user, :with_profile, :with_company, :with_trader_role, city: City.find_by(name: 'MEDELLIN'), name: 'Aquiles S.A', nit_number: '0987654321', rucom: rucom, first_name: 'nametest', last_name: 'last_nametest', document_number: '1234567890', city: City.find_by(name: 'MEDELLIN') }
    let(:gold_batch) { create :gold_batch }
    let(:sale_order) { create :sale, seller: seller, buyer: buyer, gold_batch: gold_batch, courier: courier }

    subject(:service) { Shipment::DrawPdf.new }

  context 'creation of the pdf in the service shipment draw' do
    before :each do
      @current_buyer = create(:user, :with_company, :with_trader_role).company.legal_representative
      @order = create(:sale)
    end
    it 'should check the consistency of the document' do
      binding.pry
      expected_hash = '2ebeaa2e22115cb5a6d84aad646f808e3aafe20f389ee73515becca13198d1d7'
      response = service.call(
        current_user: buyer,
        order: sale_order
      )
      system "mkdir -p #{ Rails.root }/tmp/shipment"
      saved_file = service.file.render_file("#{ Rails.root }/tmp/shipment/shipment_test.pdf")
      file_payload = File.read(saved_file)
      file_hash = Digest::SHA256.hexdigest file_payload
      expect(response[:success]).to be true
      expect(file_hash).to eq expected_hash
    end
  end
end
