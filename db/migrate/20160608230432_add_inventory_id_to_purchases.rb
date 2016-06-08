class AddInventoryIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :inventory_id, :integer
  end
end
