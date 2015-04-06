class CreateCreditBillings < ActiveRecord::Migration
  def change
    create_table :credit_billings do |t|
      t.references :user, index: true
      t.string :unit
      t.float :per_unit_value
      t.float :iva_value
      t.float :discount
      t.float :total_amount
      t.boolean :payment_flag
      t.datetime :payment_date
      t.float :discount_percentage
      t.timestamps
    end
  end
end
