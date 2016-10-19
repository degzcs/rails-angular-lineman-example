class AddAlegraSyncToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alegra_sync, :boolean, default: false
  end
end
