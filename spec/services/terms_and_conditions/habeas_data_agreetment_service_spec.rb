require 'spec_helper'

describe TermsAndConditions::HabeasDataAgreetmentService do
  subject(:service) { TermsAndConditions::HabeasDataAgreetmentService.new }

  context 'a authorized provider sign the TermsAndConditions' do
    before :each do
      settings = Settings.instance
      settings.habeas_data_agreetment = File.read("#{Rails.root}/spec/support/texts/habeas_data_disclaimer.txt")
      settings.save!
      @authorized_provider = create(:user, :with_profile, :with_personal_rucom, provider_type: 'Barequero')
      signature_picture_path = "#{Rails.root}/spec/support/images/signature.jpg"
      @signature_picture = Rack::Test::UploadedFile.new(signature_picture_path, 'image/jpeg')
    end
    after :each do
      settings = Settings.instance
      settings.habeas_data_agreetment = 'habeas agreetment text'
      settings.save!
    end

    it 'should create a pdf HabeasDataAgreetment (call)' do
      response = service.call(
        authorized_provider: @authorized_provider,
        signature_picture: @signature_picture
      )
      expect(response[:success]).to be true
      expect(@authorized_provider.profile.reload.habeas_data_agreetment_file.file.path).to match('habeas_data_agreetment.pdf')
    end
  end
end
