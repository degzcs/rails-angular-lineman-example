class AddMiningRegisterFileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mining_register_file, :string
  end
end
