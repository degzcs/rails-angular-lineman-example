class AddCreditsToAvailableTrazoroService < ActiveRecord::Migration
  def change
    add_column :available_trazoro_services, :credits, :float
  end
end
