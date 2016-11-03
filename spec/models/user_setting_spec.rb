# == Schema Information
#
# Table name: user_settings
#
#  id              :integer          not null, primary key
#  state           :boolean          default(FALSE)
#  alegra_token    :string(255)
#  profile_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  fine_gram_value :float
#

require 'spec_helper'

describe UserSetting, type: :model do
  context 'factory text' do
    let(:user_setting) { create :user_setting }
    it 'should to test the profile factory' do
      expect(user_setting).to be_valid
      expect(user_setting.profile.present?).to eq true
    end
  end

  context 'associations with available_trazoro_services' do
    it { should have_and_belong_to_many :available_trazoro_services }
  end

  context 'should show error of Validations' do
    it 'error Validations fine_gram_value is not a number' do
      setting = build :user_setting, fine_gram_value: 'text'
      setting.save
      expect(setting.errors.full_messages).to include('Fine gram value is not a number')
    end

    it 'should validate unique association between user setting and available trazoro services' do
      user_setting = create(:user_setting, :with_available_trazoro_service)
      available_trazoro_service = user_setting.available_trazoro_services.last
      expect { user_setting.available_trazoro_services << available_trazoro_service }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
