class RemoveManyWrongFieldsFromManyTables < ActiveRecord::Migration
  def change
    remove_column :states, :state_code, :string
    remove_column :cities, :state_code, :string
    remove_column :cities, :city_code, :string
    remove_column :population_centers, :population_center_type, :string
    remove_column :population_centers, :population_center_code, :string
    remove_column :population_centers, :city_code, :string
  end
end
