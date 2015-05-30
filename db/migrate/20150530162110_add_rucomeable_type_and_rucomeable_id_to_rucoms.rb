class AddRucomeableTypeAndRucomeableIdToRucoms < ActiveRecord::Migration
  def change
    add_column :rucoms, :rucomeable_type, :string
    add_column :rucoms, :rucomeable_id, :integer
  end
end
