require 'spec_helper'

describe Shipment::DrawPdf do
  subject(:service) { Shipment::DrawPdf.new }

  context 'creation of the pdf in the service shipment draw' do

  	before :each do
  		@current_buyer = create(:user, :with_company, :with_trader_role).company.legal_representative
  		@order = create(:sale)
  	end
    it 'should check the consistency of the document' do
      expected_hash = '1a638a58852b1ff763e1a5a5b5809551223d65f7aac89e9ef198f26b60b675d2'
      response = service.call(
        current_user: @current_buyer,
        order: @order,
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
