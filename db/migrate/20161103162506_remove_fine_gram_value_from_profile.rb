class RemoveFineGramValueFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :fine_gram_value, :float
  end
end
