class AddInvoicedToCreditBillings < ActiveRecord::Migration
  def change
    add_column :credit_billings, :invoiced, :boolean, default: false
  end
end
