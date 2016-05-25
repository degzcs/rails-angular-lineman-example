class RemoveDocumentNumberFileFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :document_number_file, :string
  end
end
