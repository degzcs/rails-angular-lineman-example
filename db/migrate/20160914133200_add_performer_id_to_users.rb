class AddPerformerIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :performer_id, :integer
    add_index :users, :performer_id
  end
end
