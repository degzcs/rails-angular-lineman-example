class DeleteColumnTypeofProvider < ActiveRecord::Migration
  def change
    remove_column :providers, :type
  end
end
