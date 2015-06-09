class AddTypeToExternalUser < ActiveRecord::Migration
  def change
    add_column :external_users, :user_type , :integer , default: 1, null: false
    add_column :users, :user_type , :integer , default: 1, null: false
  end
end
