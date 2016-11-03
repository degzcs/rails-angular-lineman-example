class CreateAvailableTrazoroServices < ActiveRecord::Migration
  def change
    create_table :available_trazoro_services do |t|
      t.string :name
      t.float :credist

      t.timestamps
    end
  end
end
