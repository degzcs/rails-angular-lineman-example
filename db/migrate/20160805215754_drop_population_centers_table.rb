class DropPopulationCentersTable < ActiveRecord::Migration
  def change
    drop_table :population_centers
  end
end
