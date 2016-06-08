# == Schema Information
#
# Table name: gold_batches
#
#  id              :integer          not null, primary key
#  fine_grams      :float
#  grade           :integer
#  inventory_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  extra_info      :text
#  goldomable_type :string(255)
#  goldomable_id   :integer
#

FactoryGirl.define do
  factory :gold_batch do
    fine_grams { 100 }
    grade { 850 }
    # inventory
  end
end
