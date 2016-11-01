class AddPaidAndQuantityToCreditBillings < ActiveRecord::Migration
  def change
    add_column :credit_billings, :paid, :boolean, default: false
    add_column :credit_billings, :quantity, :float
  end
end
