class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.references :purchase, index: true
      t.float :remaining_amount, :null => false
      t.boolean :status , :default => true, :null => false
      t.timestamps 
    end
  end
end
