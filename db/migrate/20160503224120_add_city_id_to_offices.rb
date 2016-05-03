class AddCityIdToOffices < ActiveRecord::Migration
  def change
    add_column :offices, :city_id, :integer
  end
end
