class AddNumRucomToRucoms < ActiveRecord::Migration
  def change
    add_column :rucoms, :num_rucom, :string
  end
end
