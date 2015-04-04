class AddPopulationCenterToProvider < ActiveRecord::Migration
  def change
    add_reference :providers, :population_center, index: true
  end
end
