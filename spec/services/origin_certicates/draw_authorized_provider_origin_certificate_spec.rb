require 'spec_helper'

describe OriginCertificates::DrawAuthorizedProviderOriginCertificate do
  let(:seller) { create :user, :with_profile, :with_personal_rucom, provider_type: 'Barequero', first_name: 'Alam', last_name: 'brito', document_number: '1234567890', city: City.find_by(name: 'MEDELLIN')
  }
  let(:rucom) { create :rucom, rucom_number: '7767899877' }
  let(:gold_batch) { create :gold_batch, fine_grams: 2.2 }
  let(:buyer) { create :user, :with_company, city: City.find_by(name: 'MEDELLIN'), name: 'Aquiles S.A', nit_number: '0987654321', rucom: rucom }
  let(:purchase_order) { create :purchase, seller: seller, buyer: buyer, gold_batch: gold_batch }

  subject(:service){ OriginCertificates::DrawAuthorizedProviderOriginCertificate.new }

  context 'check consistency of the pdf' do
    before :each do
      signature_picture_path = "#{ Rails.root }/spec/support/images/signature.jpg"
      @signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
    end

    it 'test the execution signature' do
      expected_hash = '5b153dbb0f5ac2e1eec7885a5917833695802cd42bbc0183c591a74a797fa209'
      order_presenter = OrderPresenter.new(purchase_order, nil)
      response = service.call(
        order_presenter: order_presenter,
        signature_picture: @signature_picture,
        date: '2016/07/15'.to_date
      )

      system "mkdir -p #{ Rails.root }/tmp/origin_certificates"
      saved_file = service.file.render_file("#{ Rails.root }/tmp/origin_certificates/origin_certificate_with_signature.pdf")
      file_payload = File.read(saved_file)
      file_hash = Digest::SHA256.hexdigest file_payload
      expect(response[:success]).to be true
      expect(file_hash).to eq expected_hash
    end
  end
end
