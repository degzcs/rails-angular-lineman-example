class AddReffToRucoms < ActiveRecord::Migration
  def change
    add_reference :rucoms, :provider
  end
end
