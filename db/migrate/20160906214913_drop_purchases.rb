class DropPurchases < ActiveRecord::Migration
    def up
    drop_table :purchases
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
