require 'spec_helper'

describe TermsAndConditions::HabeasDataAgreetmentService do
  subject(:service) { TermsAndConditions::HabeasDataAgreetmentService.new }

  context 'a authorized provider sign the TermsAndConditions' do
    before :each do
      @authorized_provider = create(:user, :with_profile, :with_personal_rucom, provider_type: 'Barequero')
      @signature_picture_path = "#{Rails.root}/spec/support/images/signature.png"
    end

    it 'should create a pdf HabeasDataAgreetment (call)' do
      response = service.call(
        authorized_provider: @authorized_provider,
        signature_picture: @signature_picture_path
      )
      expect(response[:success]).to be true
      expect(@authorized_provider.profile.reload.habeas_data_agreetment_file.file.path).to match('habeas_data_agreetment.pdf')
    end
  end
end
