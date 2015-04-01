class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.integer :provider_id
      t.string :origin_certificate_sequence
      t.integer :gold_batch_id
      t.float :amount
      t.string :origin_certificate_file

      t.timestamps
    end
  end
end
