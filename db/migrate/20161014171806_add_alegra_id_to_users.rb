class AddAlegraIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alegra_id, :integer
  end
end
