class CreatePopulationCenters < ActiveRecord::Migration
  def change
    create_table :population_centers do |t|
      t.string :name
      t.decimal :longitude
      t.decimal :latitude
      t.string :type
      t.references :city, index: true

      t.timestamps
    end
  end
end
