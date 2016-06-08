class AddSellerIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :seller_id, :integer
    add_index :purchases, :seller_id
  end
end
