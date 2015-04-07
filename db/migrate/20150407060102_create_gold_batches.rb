class CreateGoldBatches < ActiveRecord::Migration
  def change
    create_table :gold_batches do |t|
      t.text :parent_batches
      t.float :grams
      t.integer :grade
      t.integer :inventory_id

      t.timestamps
    end
  end
end
