class AddNitNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nit_number, :string
  end
end
