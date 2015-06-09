class RemoveFilesToUser < ActiveRecord::Migration
  def change
    remove_column :users , :mining_register_file , :string
  end
end
