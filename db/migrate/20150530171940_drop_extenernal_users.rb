class DropExtenernalUsers < ActiveRecord::Migration
   def up
    drop_table :external_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
