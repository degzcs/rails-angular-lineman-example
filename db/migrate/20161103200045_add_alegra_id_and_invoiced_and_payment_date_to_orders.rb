class AddAlegraIdAndInvoicedAndPaymentDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :alegra_id, :integer
    add_column :orders, :invoiced, :boolean, default: false
    add_column :orders, :payment_date, :datetime
  end
end
