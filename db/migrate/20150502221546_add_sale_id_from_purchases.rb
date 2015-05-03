class AddSaleIdFromPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :sale_id, :integer
  end
end
