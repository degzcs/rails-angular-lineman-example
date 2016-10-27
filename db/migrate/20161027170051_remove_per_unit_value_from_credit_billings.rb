class RemovePerUnitValueFromCreditBillings < ActiveRecord::Migration
  def change
    remove_column :credit_billings, :per_unit_value, :float
  end
end
