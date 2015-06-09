class DropExternalClientTable < ActiveRecord::Migration
  def up
    drop_table :external_clients
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
