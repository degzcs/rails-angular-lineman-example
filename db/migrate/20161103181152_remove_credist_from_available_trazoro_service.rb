class RemoveCredistFromAvailableTrazoroService < ActiveRecord::Migration
  def change
    remove_column :available_trazoro_services, :credist, :float
  end
end
