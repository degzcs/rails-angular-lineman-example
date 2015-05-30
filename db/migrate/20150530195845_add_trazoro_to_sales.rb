class AddTrazoroToSales < ActiveRecord::Migration
  def change
    add_column :sales, :trazoro, :boolean, default: false, null: false
  end
end
