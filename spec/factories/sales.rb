# == Schema Information
#
# Table name: sales
#
#  id                      :integer          not null, primary key
#  courier_id              :integer
#  client_id               :integer
#  user_id                 :integer
#  gold_batch_id           :integer
#  code                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  origin_certificate_file :string(255)
#  price                   :float
#  trazoro                 :boolean          default(FALSE), not null
#

FactoryGirl.define do
  factory :sale do
    courier
    user { User.where(email: 'jesus.munoz@trazoro.co').first || create(:user) } # Seller
    client { User.where(email: 'diego.gomez@trazoro.co').first || create(:external_user) } # Buyer
    gold_batch # bought gold in this transaction.
    code "123456789"
    price { 100 }
    origin_certificate_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'origin_certificate_file.pdf')) }

    trait :with_batches do
      transient do
        number_of_batches { 3 }
      end
      after :create do |sale, e|
        provider = User.where(email: 'tech@trazoro.co').first || create(:external_user)
        e.number_of_batches.times do |index|
          purchase = create(:purchase, user: sale.user, provider: provider)
          create(:sold_batch, sale: sale, purchase: purchase )
        end
      end
    end
  end
end
