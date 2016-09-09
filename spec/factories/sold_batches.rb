# == Schema Information
#
# Table name: sold_batches
#
#  id            :integer          not null, primary key
#  grams_picked  :float
#  created_at    :datetime
#  updated_at    :datetime
#  gold_batch_id :integer
#  order_id      :integer
#

FactoryGirl.define do
  factory :sold_batch do
    # grams_picked 2.5
    order

    transient do
      number_of_batches { 3 }
    end

    after :build do |sold_batch, e|
      #current_user = create :user, :with_company, :with_trader_role
      e.number_of_batches.times do |index|
        sold_batch.gold_batch = create(:purchase,
          :with_proof_of_purchase_file,
          :with_origin_certificate_file,
          :with_performer_user).gold_batch
      end
    end
  end
end
