class AddInventoryIdAndBuyerIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :inventory_id, :integer
    add_column :sales, :buyer_id, :integer
    add_index :sales, :inventory_id
    add_index :sales, :buyer_id
  end
end
