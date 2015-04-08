class AddNewParamsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :available_credits, :float
  end
end
