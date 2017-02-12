# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  password_digest    :string(255)
#  reset_token        :string(255)
#  office_id          :integer
#  registration_state :string(255)
#  alegra_id          :integer
#  alegra_sync        :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :user, class: User do |_f|
    email { Faker::Internet.email }
    personal_rucom {}
    office {}
    password { 'foobar' }
    password_confirmation { 'foobar' }

    trait :with_profile do
      transient do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        document_number { Faker::Number.number(10) }
        phone_number { Faker::PhoneNumber.cell_phone }
        available_credits { 0 }
        address { Faker::Address.street_address }
        setting { create :user_setting }
        rut_file do
          Rack::Test::UploadedFile
            .new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'), 'application/pdf')
        end
        photo_file do
          Rack::Test::UploadedFile
            .new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'), 'image/jpeg')
        end
        mining_authorization_file do
          Rack::Test::UploadedFile
            .new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'mining_register_file.pdf'), 'application/pdf')
        end
        legal_representative { false }
        id_document_file do
          Rack::Test::UploadedFile
            .new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'id_document_file.pdf'), 'application/pdf')
        end
        habeas_data_agreetment do
          Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'habeas_data_agreetment.pdf'), 'application/pdf')
        end

        signature_picture_file do
          Rack::Test::UploadedFile
            .new(File.join(Rails.root, 'spec', 'support', 'images', 'signature_picture.png'), 'image/jpeg')
        end

        nit_number { Faker::Number.number(10) }
        city { City.all.sample }
      end

      after :create do |user, e|
        user.build_profile
        user.profile.first_name = e.first_name
        user.profile.last_name = e.last_name
        user.profile.document_number = e.document_number
        user.profile.phone_number = e.phone_number
        user.profile.available_credits = e.available_credits
        user.profile.address = e.address
        user.profile.rut_file = e.rut_file
        user.profile.photo_file = e.photo_file
        user.profile.mining_authorization_file = e.mining_authorization_file
        user.profile.legal_representative = e.legal_representative
        user.profile.id_document_file = e.id_document_file
        user.profile.habeas_data_agreetment_file = e.habeas_data_agreetment
        user.profile.nit_number = e.nit_number
        user.profile.city = e.city
        user.profile.setting = e.setting
        user.save!
      end
    end

    trait :with_personal_rucom do
      transient do
        provider_type { 'Titular' }
      end
      before :create do |user, e|
        user.personal_rucom = create(:rucom, provider_type: e.provider_type)
      end
    end

    trait :with_company do
      transient do
        city { City.all.sample }
        name { "Test company SAS #{ Company.count }" }
        nit_number { Faker::Number.number(10) }
        rucom { build :rucom }
        address { Faker::Address.street_address }
        phone_number { Faker::PhoneNumber.cell_phone }
        company_email { Faker::Internet.email }
      end
      before :create do |user, e|
        user.office = create(:company,
                              city: e.city,
                              name: e.name,
                              nit_number: e.nit_number,
                              rucom: e.rucom,
                              address: e.address,
                              phone_number: e.phone_number,
                              email: e.company_email
                            ).main_office
      end
    end

    trait :with_authorized_provider_role do
      before :create do |user, _e|
        role = Role.find_by(name: 'authorized_provider')
        user.roles << role
      end
    end

    trait :with_final_client_role do
      before :create do |user, _e|
        role = Role.find_by(name: 'final_client')
        user.roles << role
      end
    end

    trait :with_trader_role do
      before :create do |user, _e|
        role = Role.find_by(name: 'trader')
        user.roles << role
      end
    end

    trait :with_transporter_role do
      before :create do |user, _e|
        role = Role.find_by(name: 'transporter')
        user.roles << role
      end
    end
  end
end
