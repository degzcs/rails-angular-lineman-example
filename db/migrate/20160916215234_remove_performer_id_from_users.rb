class RemovePerformerIdFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :performer_id
    remove_column :users, :performer_id, :integer
  end
end
