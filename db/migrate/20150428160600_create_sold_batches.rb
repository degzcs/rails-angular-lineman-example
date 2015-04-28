class CreateSoldBatches < ActiveRecord::Migration
  def change
    create_table :sold_batches do |t|
      t.integer :purchase_id
      t.float :grams_picked
      t.references :sale, index: true
      t.timestamps
    end
  end
end
