class RemoveGramsFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :grams, :float
  end
end
