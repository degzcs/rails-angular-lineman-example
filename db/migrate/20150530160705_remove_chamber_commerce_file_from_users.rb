class RemoveChamberCommerceFileFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :chamber_commerce_file, :string
  end
end
