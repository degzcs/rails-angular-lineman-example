class AddCityCodeAndPopulationCenterCodeToPopulationCenter < ActiveRecord::Migration
  def change
    add_column :population_centers, :population_center_code, :string, null: false
    add_column :population_centers, :city_code, :string, null: false
  end
end
