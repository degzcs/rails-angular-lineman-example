class RemoveUserIdAndClientIdFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :user_id, :integer
    remove_column :sales, :client_id, :integer
  end
end
