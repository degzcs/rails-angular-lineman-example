class AddPopulationCenterToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :population_center, index: true
  end
end
