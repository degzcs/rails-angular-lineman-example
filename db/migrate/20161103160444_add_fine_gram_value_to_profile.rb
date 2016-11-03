class AddFineGramValueToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :fine_gram_value, :float
  end
end
