# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  first_name               :string(255)
#  last_name                :string(255)
#  email                    :string(255)
#  document_number          :string(255)
#  document_expedition_date :date
#  phone_number             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  password_digest          :string(255)
#  available_credits        :float
#  reset_token              :string(255)
#  address                  :string(255)
#  document_number_file     :string(255)
#  photo_file               :string(255)
#  population_center_id     :integer
#  office_id                :integer
#  external                 :boolean          default(FALSE), not null
#  rut_file                 :string(255)
#

FactoryGirl.define do

  factory :user, class: User do |f|
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name}
    email { Faker::Internet.email }
    document_number { Faker::Number.number(10) }
    document_expedition_date 50.years.ago
    phone_number { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_address}
    document_number_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'photo_file.png'),"image/jpeg") }
    rut_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'photo_file.png'),"image/jpeg") }
    photo_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_images', 'photo_file.png'),"image/jpeg") }
    personal_rucom {}
    office
    population_center
    password {'foobar'}
    password_confirmation {'foobar'}
    external {false}

    factory :external_user, class: User do
        personal_rucom { create :rucom}
        external {true}
        password {nil}
        password_confirmation {nil}

        factory :client_with_fake_rucom, class: User do
            personal_rucom { create(:rucom, :for_clients)}
        end
    end

  end
end
