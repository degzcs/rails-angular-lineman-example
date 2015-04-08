class RemoveAmountFromPurchasesAddPriceToPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :amount, :float
    add_column :purchases, :price, :float
  end
end
