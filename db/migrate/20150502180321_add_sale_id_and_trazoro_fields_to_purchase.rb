class AddSaleIdAndTrazoroFieldsToPurchase < ActiveRecord::Migration
  def change
    add_reference :purchases, :client, index: true
    add_column :purchases, :trazoro, :boolean, null: false, default: false
  end
end
