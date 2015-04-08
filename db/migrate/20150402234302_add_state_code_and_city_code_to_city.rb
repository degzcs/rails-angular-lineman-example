class AddStateCodeAndCityCodeToCity < ActiveRecord::Migration
  def change
    add_column :cities, :state_code, :string, null: false
    add_column :cities, :city_code, :string, null: false
  end
end
