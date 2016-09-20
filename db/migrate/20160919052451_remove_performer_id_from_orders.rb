class RemovePerformerIdFromOrders < ActiveRecord::Migration
  def change
    remove_index :orders, :performer_id
    remove_column :orders, :performer_id, :integer
  end
end
