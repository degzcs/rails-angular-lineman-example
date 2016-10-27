require 'spec_helper'

describe TermsAndConditions::DrawPdf do
  subject(:service) { TermsAndConditions::DrawPdf.new }

  context 'creation of the pdf in the service habeas_data_agreetment draw' do
    before :each do
      seller = create(:user, :with_profile, :with_personal_rucom, provider_type: 'Barequero')
      @seller_presenter = UserPresenter.new(seller, nil)
      signature_picture_path = "#{Rails.root}/spec/support/images/signature.png"
      @signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
    end
    it 'should check the consistency of the document' do
      expected_hash = '00948c31cb0b1420b45b2ae29617c2db4aefe8cfc7a42df5801fc8c158cc6a41'
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
