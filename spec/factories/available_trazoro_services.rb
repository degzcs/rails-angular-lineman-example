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

FactoryGirl.define do
  factory :available_trazoro_service do
    name 'test'
    credits 1.5

    trait :with_user_setting do
      transient do
        state true
        alegra_token ''
      end
      after :create do |available_trazoro_service, e|
        available_trazoro_service.user_settings << create(:user_setting, state: e.state, alegra_token: e.alegra_token)
      end
    end
  end
end
