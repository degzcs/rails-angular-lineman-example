class AddCorrectFieldsToManyTables < ActiveRecord::Migration
  def change
    add_column :states, :code, :string
    add_column :cities, :code, :string
    add_column :population_centers, :type, :string
    add_column :population_centers, :code, :string
  end
end
