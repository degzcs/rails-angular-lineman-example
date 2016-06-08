class RemoveSaleIdFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :sale_id, :integer
  end
end
