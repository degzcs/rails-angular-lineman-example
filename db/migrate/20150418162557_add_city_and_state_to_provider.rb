class AddCityAndStateToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :city, :string
    add_column :providers, :state, :string
  end
end
