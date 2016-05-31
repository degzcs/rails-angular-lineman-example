class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users do |t|
      t.integer :user_id
      t.integer :role_id
    end
    add_index :roles_users, [:user_id, :role_id], :unique => true
  end
end
