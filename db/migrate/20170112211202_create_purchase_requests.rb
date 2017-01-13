class CreatePurchaseRequests < ActiveRecord::Migration
  def change
    create_table :purchase_requests do |t|
      t.integer :order_id
      t.integer :buyer_id
    end
    add_index :purchase_requests, [:order_id, :buyer_id], unique: true
  end
end
