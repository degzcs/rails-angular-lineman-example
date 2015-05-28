class NewRucomFields < ActiveRecord::Migration
  def change
    add_reference :rucoms, :trazoro_user, polymorphic: true, index: true
  end
end
