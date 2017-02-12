require 'spec_helper'

describe TermsAndConditions::DrawPdf do
  subject(:service) { TermsAndConditions::DrawPdf.new }

  context 'creation of the pdf in the service habeas_data_agreetment draw' do
    before :each do
      Timecop.freeze(2017, 2, 12, 10, 5, 0)
      seller = create(:user, :with_profile, :with_personal_rucom, provider_type: 'Barequero', document_number: '1234567890', first_name: 'Teng', last_name: 'Jambre', city: City.where(name: 'MEDELLIN').first)
      @seller_presenter = UserPresenter.new(seller, nil)
      signature_picture_path = "#{Rails.root}/spec/support/images/signature.png"
      @signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
      settings = Settings.instance
      settings.data = { monthly_threshold: 30, fine_gram_value: 1000, vat_percentage: 16, fixed_sale_agreetment: "fixed sale agreetment text", habeas_data_agreetment: "habeas agreetment text" }
      settings.save!
    end

    after :each do
      Timecop.return
    end

    it 'should check the consistency of the document' do
      expected_hash = 'b5bc5dba6a1070b7bb25fda10d62c01f8ca790acf6c976fd06101a45b8f660e0'
      response = service.call(
        authorized_provider_presenter: @seller_presenter,
        signature_picture: @signature_picture
      )
      system "mkdir -p #{ Rails.root }/tmp/terms_and_conditions"
      saved_file = service.file.render_file("#{ Rails.root }/tmp/terms_and_conditions/habeas_data_agreetment_test.pdf")
      file_payload = File.read(saved_file)
      file_hash = Digest::SHA256.hexdigest file_payload
      expect(response[:success]).to be true
      expect(file_hash).to eq expected_hash
    end
  end
end
