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

ActiveAdmin.register Order do
  menu priority: 7, label: 'Ordenes (Transacciones)'

  actions :index, :show
  permit_params :buyer_id, :seller_id, :gold_batch_id, :origin_certificate_file, :price, :seller_id

  index do
    selectable_column
    id_column
    column(:buyer_id) do |purchase|
      purchase.buyer_id
    end
    column(:seller_id) do |purchase|
      purchase.seller_id
    end
    column(:gold_batch) do |purchase|
      purchase.gold_batch.fine_grams
    end
    column :documents
    column :price
    actions
  end

  # filter :user
  filter :seller_id
  filter :buyer_id
  filter :rucom_record
  filter :gold_batch
  filter :documents
  filter :price
end
