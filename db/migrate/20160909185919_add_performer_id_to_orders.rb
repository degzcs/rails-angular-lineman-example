class AddPerformerIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :performer_id, :integer
    add_index :orders, :performer_id
  end
end
