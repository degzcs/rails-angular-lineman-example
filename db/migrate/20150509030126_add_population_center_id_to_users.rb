class AddPopulationCenterIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :population_center_id, :integer
  end
end
