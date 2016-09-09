# == Schema Information
#
# Table name: sales
#
#  id           :integer          not null, primary key
#  courier_id   :integer
#  code         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  price        :float
#  trazoro      :boolean          default(FALSE), not null
#  inventory_id :integer
#  buyer_id     :integer
#

FactoryGirl.define do
  factory :sale, class: Order do
    courier
    seller { create(:user, :with_personal_rucom, :with_authorized_provider_role) }
    buyer { create(:user, :with_company, :with_trader_role) }
    gold_batch { create :gold_batch } # bought gold in this transaction.
    type 'sale'
    code "123456789"
    price { 100 }
    performer { buyer }

    trait :with_proof_of_sale_file do
      after :create do |sale, e|
        sale.documents.build(
        file: File.open(File.join(Rails.root, 'spec', 'support', 'pdfs', 'documento_equivalente_de_venta.pdf')),
        type: 'equivalent_document',
        )
        sale.save!
      end
    end

    trait :with_purchase_files_collection_file do
      after :create do |sale, e|
        sale.documents.build(
        file: File.open(File.join(Rails.root, 'spec', 'support', 'pdfs', 'documento_equivalente_de_venta.pdf')),
        type: 'purchase_files_collection',
        )
        sale.save!
      end
    end

    trait :with_batches do
      transient do
        number_of_batches { 3 }
      end
      after :create do |sale, e|
        seller = User.where(email: 'tech@trazoro.co').first || create(:user, :with_personal_rucom, :with_authorized_provider_role)
        e.number_of_batches.times do |index|
          purchase = create(:purchase,
            :with_origin_certificate_file,
            :with_proof_of_purchase_file,
            buyer: sale.buyer,
            seller: seller)
          create(:sold_batch, order: sale, gold_batch: purchase.gold_batch )
        end
      end
    end
  end
end
