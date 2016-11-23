class AddReferenceToAvailableTrazoroServices < ActiveRecord::Migration
  def change
    add_column :available_trazoro_services, :reference, :string
  end
end
