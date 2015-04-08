class FixColumnNameTypeInPopulationCenter < ActiveRecord::Migration
  def self.up
    rename_column :population_centers, :type, :population_center_type
  end

  def self.down
    # rename back if you need or do something else or do nothing
    rename_column :population_centers, :population_center_type, :type
  end
end
