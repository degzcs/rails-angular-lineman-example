require 'spec_helper'

describe TermsAndConditions::DrawPdf do
  subject(:service) { TermsAndConditions::DrawPdf.new }

  context 'creation of the pdf in the service habeas_data_agreetment draw' do
    before :each do
      @seller = create(:user, :with_profile, :with_personal_rucom, provider_type: 'Barequero')
      @signature_picture_path = "#{Rails.root}/spec/support/images/signature.png"
    end
    it 'should check the consistency of the document' do
      expected_hash = 'f7d9c940556349de8983bfa1de1e4dc8316e24a5719a811c20a2418ded517c57'
      response = service.call(
        authorized_provider_presenter: @seller,
        signature_picture: @signature_picture_path
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
