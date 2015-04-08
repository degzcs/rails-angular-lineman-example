class CreateCreditBillings < ActiveRecord::Migration
  def change
    create_table :credit_billings do |t|
      t.references :user, index: true
      t.integer :unit
      t.float :per_unit_value
      t.boolean :payment_flag , :default => false
      t.datetime :payment_date
      t.float :discount_percentage
      t.timestamps
    end
  end
end
