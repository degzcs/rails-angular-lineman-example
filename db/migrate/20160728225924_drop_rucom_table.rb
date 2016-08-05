class DropRucomTable < ActiveRecord::Migration
  def change
    drop_table :rucoms
  end
end
