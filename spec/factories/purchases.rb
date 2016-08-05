# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  origin_certificate_sequence :string(255)
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#  seller_picture              :string(255)
#  code                        :text
#  trazoro                     :boolean          default(FALSE), not null
#  seller_id                   :integer
#  inventory_id                :integer
#

FactoryGirl.define do
  factory :purchase do
    seller { create(:user, :with_company) } # seller
    inventory { create(:inventory) }
    gold_batch { create(:gold_batch) }
    origin_certificate_sequence { Faker::Code.isbn }
    # origin_certificate_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'origin_certificate_file.pdf'),"application/pdf") }
    price { 1_000_000 }
    seller_picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'),"image/jpeg") }
    trazoro { false }

    trait :with_origin_certificate_file do
      after :build do |purchase, _e|
        purchase.documents.build(
        file: File.open(File.join(Rails.root, 'spec', 'support', 'pdfs', 'origin_certificate_file.pdf')),
        type: 'origin_certificate',
        )
        # purchase.save!
      end
    end

    trait :with_proof_of_purchase_file do
      after :build do |purchase, e|
        purchase.documents.build(
        file: File.open(File.join(Rails.root, 'spec', 'support', 'pdfs', 'documento_equivalente_de_compra.pdf')),
        type: 'equivalent_document',
        )
        # purchase.save!
      end
    end
  end

end
