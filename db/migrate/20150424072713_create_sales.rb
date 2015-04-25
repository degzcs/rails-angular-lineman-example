class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :courier_id, index: true
      t.integer :client_id, index: true
      t.integer :user_id, index: true
      t.integer :gold_batch_id, index: true
      t.float :grams
      t.string :barcode
      t.timestamps
    end
  end
end
