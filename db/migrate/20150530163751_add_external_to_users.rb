class AddExternalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :external, :boolean, default: false, null: false
  end
end
