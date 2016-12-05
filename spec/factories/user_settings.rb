# == Schema Information
#
# Table name: user_settings
#
#  id                        :integer          not null, primary key
#  state                     :boolean          default(FALSE)
#  alegra_token              :string(255)
#  profile_id                :integer
#  created_at                :datetime
#  updated_at                :datetime
#  fine_gram_value           :float
#  last_transaction_sequence :integer          default(0)
#

FactoryGirl.define do
  factory :user_setting do
    state true
    alegra_token {"fakeToken#{ UserSetting.count + 1 }"}
    profile
    fine_gram_value 0.0
    last_transaction_sequence 0

    trait :with_available_trazoro_service do
      transient do
        name { Faker::Name.name }
        credits 0
      end
      after :create do |user_setting, e|
        user_setting.trazoro_services << create(:available_trazoro_service, name: e.name, credits: e.credits)
      end
    end
  end
end
