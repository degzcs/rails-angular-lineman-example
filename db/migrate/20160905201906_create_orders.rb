class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.integer :courier_id
      t.string :type
      t.string :code
      t.float :price
      t.string :seller_picture
      t.boolean :trazoro, default: false, null: false
      t.timestamps
    end
  end
end
