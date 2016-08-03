# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
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
        email { Faker::Internet.email }
        personal_rucom {}
        office {}
        profile
        password { 'foobar' }
        password_confirmation { 'foobar' }
        external { false }

        trait :with_profile do
            transient do
                first_name { Faker::Name.first_name }
                last_name { Faker::Name.last_name}
                document_number { Faker::Number.number(10) }
                phone_number { Faker::PhoneNumber.cell_phone }
                available_credits { 0 }
                address { Faker::Address.street_address}
                rut_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'),"application/pdf") }
                photo_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'),"image/jpeg") }
                mining_authorization_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'mining_register_file.pdf'),"application/pdf") }
                legal_representative { false }
                id_document_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'document_number_file.pdf'),"application/pdf") }
                nit_number { Faker::Number.number(10) }
                city { City.all.sample }
            end


      after :build do |user, e|
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
        user.profile.nit_number = e.nit_number
        user.profile.city = e.city
      end
    end

    trait :with_personal_rucom do
      transient do
        provider_type { 'Titular'}
      end
      before :create do |user, e|
        user.personal_rucom = create(:rucom, provider_type: e.provider_type)
      end
    end

    trait :with_company do
      transient do
         city_name { City.all.sample.name }
         name { 'MinTrace SAS' }
         nit_number { Faker::Number.number(10) }
         rucom { create :rucom }
      end
      before :create do |user, e|
        user.office = create(:company, city: e.city_name, name: e.name, nit_number: e.nit_number, rucom: e.rucom).main_office
      end
    end


        trait :with_authorized_producer_role do
            before :create do |user, e|
                role = Role.find_by(name: "authorized_producer")
                user.roles << role
            end
        end

        trait :with_final_client_role do
            before :create do |user, e|
                role = Role.find_by(name: "final_client")
                user.roles << role
            end
        end

        trait :with_trader_role do
            before :create do |user, e|
                role = Role.find_by(name: "trader")
                user.roles << role
            end
        end

        trait :with_transporter_role do
            before :create do |user, e|
                role = Role.find_by(name: "transporter")
                user.roles << role
            end
        end

        factory :external_user, class: User do
            personal_rucom { create :rucom }
            external { true }
            password { nil }
            password_confirmation { nil }
        end

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

