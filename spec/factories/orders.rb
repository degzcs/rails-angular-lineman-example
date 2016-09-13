# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  buyer_id       :integer
#  seller_id      :integer
#  courier_id     :integer
#  type           :string(255)
#  code           :string(255)
#  price          :string(255)
#  seller_picture :string(255)
#  trazoro        :boolean          default(FALSE), not null
#  boolean        :boolean          default(FALSE), not null
#  created_at     :datetime
#  updated_at     :datetime
#

FactoryGirl.define do
  factory :order do
    seller { create(:user, :with_company) } # seller
    buyer { create(:user, :with_company) } # seller
    # inventory { create(:inventory) }
    gold_batch { create(:gold_batch) }
    # origin_certificate_sequence { Faker::Code.isbn }
    # origin_certificate_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'pdfs', 'origin_certificate_file.pdf'),"application/pdf") }
    price { 1_000_000 }
    seller_picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'photo_file.png'), 'image/jpeg') }
    trazoro { false }
    performer { buyer }

    trait :with_origin_certificate_file do
      after :build do |purchase, _e|
        purchase.documents.build(
          file: File.open(File.join(Rails.root, 'spec', 'support', 'pdfs', 'origin_certificate_file.pdf')),
          type: 'origin_certificate'
        )
        # purchase.save!
      end
    end

    trait :with_proof_of_purchase_file do
      after :build do |purchase, _e|
        purchase.documents.build(
          file: File.open(File.join(Rails.root, 'spec', 'support', 'pdfs', 'documento_equivalente_de_compra.pdf')),
          type: 'equivalent_document'
        )
        # purchase.save!
      end
    end

    trait :with_performer_user do
      before :save do |purchase, _e|
        purchase.performer = purchase.buyer
        # purchase.save!
      end
    end
  end
end
