
# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  provider_id                 :integer
#  origin_certificate_sequence :string(255)
#  gold_batch_id               :integer
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#

ActiveAdmin.register Purchase do
  menu priority: 7, label: 'Compras'

  actions :index, :show
  permit_params :user_id, :provider_id, :origin_certificate_sequence, :gold_batch_id, :origin_certificate_file , :price

  index do
    selectable_column
    id_column
    column :user
    column :provider
    column(:gold_batch) do |purchase|
      purchase.gold_batch.fine_grams
    end
    column :origin_certificate_file
    column :price
    column :inventory
    actions
  end

  filter :user
  filter :provider
  filter :rucom_record
  filter :gold_batch
  filter :origin_certificate_file
  filter :price
  filter :inventory



end