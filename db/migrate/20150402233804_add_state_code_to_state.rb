class AddStateCodeToState < ActiveRecord::Migration
  def change
    add_column :states, :state_code, :string, null: false
  end
end
