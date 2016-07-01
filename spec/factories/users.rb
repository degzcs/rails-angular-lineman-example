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
    document_number { Faker::Number.number(10) }
    document_expedition_date 50.years.ago # NOTE : this field is useless.
    nit_number { Faker::Number.number(10) }
    phone_number { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_address}
    id_document_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'document_number_file.pdf'),"application/pdf") }
    rut_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'rut_file.pdf'),"application/pdf") }
    photo_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'),"image/jpeg") }
    mining_register_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'mining_register_file.pdf'),"application/pdf") }
    personal_rucom {}
    office {}
    # population_center
    city { City.all.sample }
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
