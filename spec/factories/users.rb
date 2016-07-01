# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  reset_token     :string(255)
#  external        :boolean          default(FALSE), not null
#  office_id       :string(255)
#

FactoryGirl.define do

  factory :user, class: User do |f|
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name}
    email { Faker::Internet.email }

    document_expedition_date 50.years.ago # NOTE : this field is useless.
    personal_rucom {}
    office {}
    # population_center

    password { 'foobar' }
    password_confirmation { 'foobar' }
    external { false }
    legal_representative { false }

    trait :with_personal_rucom do
      before :create do |user, e|
        user.personal_rucom = create(:rucom)
      end
    end

    trait :with_company do
      before :create do |user, e|
        user.office = create(:company).main_office
      end
    end

    factory :external_user, class: User do
        personal_rucom { create :rucom }
        external { true }
        password { nil }
        password_confirmation { nil }

        factory :client_with_fake_personal_rucom, class: User do
            personal_rucom { create(:rucom, :for_clients)}
            office nil
        end

        factory :client_with_fake_rucom, class: User do
            personal_rucom nil
            office { create(:company).main_office }
        end
    end

  end
end
