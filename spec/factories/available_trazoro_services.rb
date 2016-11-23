# == Schema Information
#
# Table name: available_trazoro_services
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  credits    :float
#  reference  :string(255)
#

FactoryGirl.define do
  factory :available_trazoro_service do
    name { Faker::Name.first_name }
    credits 1.5
    reference { Faker::Name.first_name }

    trait :with_user_setting do
      transient do
        state true
        alegra_token ''
        fine_gram_value 1.8
      end
      after :create do |available_trazoro_service, e|
        available_trazoro_service.user_settings << create(:user_setting, state: e.state, alegra_token: e.alegra_token, fine_gram_value: e.fine_gram_value)
      end
    end
  end
end
