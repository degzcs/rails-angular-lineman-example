class DropSales < ActiveRecord::Migration
  def up
    drop_table :sales
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
