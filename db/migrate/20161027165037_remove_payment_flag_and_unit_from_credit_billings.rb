class RemovePaymentFlagAndUnitFromCreditBillings < ActiveRecord::Migration
  def change
    remove_column :credit_billings, :payment_flag, :boolean
    remove_column :credit_billings, :unit, :integer
  end
end
