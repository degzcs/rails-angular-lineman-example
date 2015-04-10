class AddTotalToCreditBillings < ActiveRecord::Migration
  def up
    add_column :credit_billings, :total_amount, :float, :default => 0 , :null => false
    add_column :credit_billings, :discount, :float, :default => 0 , :null => false
    change_column :credit_billings, :discount_percentage, :float, :default => 0 , :null => false
  end

  def down
    remove_column :credit_billings, :total_amount 
    remove_column :credit_billings, :discount, :float, :default => 0 , :null => false
    change_column :credit_billings, :discount_percentage, :float, :default => nil , :null => true
  end
end
