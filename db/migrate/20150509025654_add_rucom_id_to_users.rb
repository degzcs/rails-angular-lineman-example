class AddRucomIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rucom_id, :integer
  end
end
