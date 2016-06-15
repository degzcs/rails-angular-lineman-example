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
  factory :sale do
    courier
    inventory { create(:inventory) } # Seller
    buyer { User.where(email: 'diego.gomez@trazoro.co').first || create(:external_user) } # Buyer
    gold_batch { create :gold_batch }# bought gold in this transaction.
    code "123456789"
    price { 100 }

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
        seller = User.where(email: 'tech@trazoro.co').first || create(:external_user)
        e.number_of_batches.times do |index|
          purchase = create(:purchase, :with_proof_of_purchase_file, user: sale.user, seller: seller)
          create(:sold_batch, sale: sale, gold_batch: purchase.gold_batch )
        end
      end
    end
  end
end
