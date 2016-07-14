require 'spec_helper'

describe OriginCertificates::DrawAuthorizedProviderOriginCertificate do

  let(:seller) { create :user, :with_profile, :with_personal_rucom, provider_type: 'Barequero', first_name: 'Alam', last_name: 'brito', document_number: '1234567890', city: City.find_by(name: 'MEDELLIN')
  }

  let(:rucom) { create :rucom, num_rucom: '7767899877' }
  let(:gold_batch) { create :gold_batch, fine_grams: 2.2 }

  let(:buyer) { create :user, :with_company, city: 'MEDELLIN', name: 'Aquiles S.A', nit_number: '0987654321', rucom: rucom }

  let(:purchase) { create :purchase, seller: seller, inventory: buyer.inventory, gold_batch: gold_batch }

  subject(:service){ OriginCertificates::DrawAuthorizedProviderOriginCertificate.new }

  context 'trazoro user (from externanl user) ' do
    before :each do
     signature_picture_path = "#{ Rails.root }/spec/support/images/signature.png"
     @signature_picture =  Rack::Test::UploadedFile.new(signature_picture_path, "image/jpeg")
    end

    it 'test the execution signature' do
      #expected_hash = "\t\x89T\xB6\xC0\x9E\x18\xE1\x96\xC7\x94\xCA\xA7\x84\xD7\x01\xA9R\xDFuj\x1E(3^\xC9\xC2\xA0'\xF9:\xD6"
      #binding.pry
      #1
      response = service.call(
       purchase: purchase,
       signature_picture: @signature_picture,
      )

      system "mkdir -p #{ Rails.root }/tmp/origin_certificates"
      saved_file = service.file.render_file("#{ Rails.root }/tmp/origin_certificates/origin_certificate_with_signature.pdf")
      #file_payload = File.read(saved_file)
      #file_hash = Digest::SHA256.hexdigest file_payload
      expect(response[:success]).to be true
      #expect(file_hash).to eq expected_hash

    end
  end
end