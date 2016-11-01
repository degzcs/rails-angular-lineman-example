class AddUnitPriceToCreditBillings < ActiveRecord::Migration
  def change
    add_column :credit_billings, :unit_price, :float
  end
end
