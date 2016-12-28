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
    regime_type { 'RS' }
    activity_code {[]}
    scope_of_operation ''
    organization_type ''
    self_holding_agent ''

    trait :with_regime_type_rc_no_self_holding do
      transient do
        regime_type { 'RC' }
        activity_code { '19'}
        organization_type { 'SAS'}
        self_holding_agent { false }
      end
      before :create do |user_setting, e|
        user_setting.regime_type = e.regime_type
        user_setting.activity_code = e.activity_code
        user_setting.regime_type = e.regime_type
        user_setting.self_holding_agent = e.self_holding_agent
      end
    end

    trait :with_regime_type_rc_and_self_holding do
      transient do
        regime_type { 'RC' }
        activity_code { '19'}
        organization_type { 'SAS'}
        self_holding_agent { true }
      end
      before :create do |user_setting, e|
        user_setting.regime_type = e.regime_type
        user_setting.activity_code = e.activity_code
        user_setting.regime_type = e.regime_type
        user_setting.self_holding_agent = e.self_holding_agent
      end
    end

    trait :with_regime_type_gc_no_self_holding do
      transient do
        regime_type { 'GC' }
        activity_code { '13'}
        organization_type { 'CI'}
        self_holding_agent { false }
      end
      before :create do |user_setting, e|
        user_setting.regime_type = e.regime_type
        user_setting.activity_code = e.activity_code
        user_setting.regime_type = e.regime_type
        user_setting.self_holding_agent = e.self_holding_agent
      end
    end

    trait :with_regime_type_gc_and_self_holding do
      transient do
        regime_type { 'GC' }
        activity_code { '13'}
        organization_type { 'CI'}
        self_holding_agent { true }
      end
      before :create do |user_setting, e|
        user_setting.regime_type = e.regime_type
        user_setting.activity_code = e.activity_code
        user_setting.regime_type = e.regime_type
        user_setting.self_holding_agent = e.self_holding_agent
      end
    end

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
