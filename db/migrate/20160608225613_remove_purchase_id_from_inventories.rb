class RemovePurchaseIdFromInventories < ActiveRecord::Migration
  def change
    remove_column :inventories, :purchase_id, :integer
  end
end
