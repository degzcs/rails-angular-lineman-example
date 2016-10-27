class AddAlegraIdToCreditBillings < ActiveRecord::Migration
  def change
    add_column :credit_billings, :alegra_id, :integer
  end
end
