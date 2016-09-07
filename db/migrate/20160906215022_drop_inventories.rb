class DropInventories < ActiveRecord::Migration
  def up
    drop_table :inventories
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
