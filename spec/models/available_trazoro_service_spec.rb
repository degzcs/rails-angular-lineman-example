# == Schema Information
#
# Table name: available_trazoro_services
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  credits    :float
#

require 'spec_helper'

describe AvailableTrazoroService, type: :model do
  context 'factory text' do
    let(:trazoro_service) { create :available_trazoro_service }
    it 'should to test the profile factory' do
      expect(trazoro_service).to be_valid
    end

    context 'Validations' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:credits) }
    end
  end

  context 'associations with user_settings' do
    it { should have_and_belong_to_many :user_settings }
  end

  context 'should show error of Validations' do
    it 'error Validations Credist is not a number' do
      trazoro_service = build :available_trazoro_service, credits: 'text'
      trazoro_service.save
      expect(trazoro_service.errors.full_messages).to include('Credits is not a number')
    end

    it 'should validate unique association between available trazoro services and user setting' do
      trazoro_service = create(:available_trazoro_service, :with_user_setting)
      user_setting = trazoro_service.user_settings.last
      expect { trazoro_service.user_settings << user_setting }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
