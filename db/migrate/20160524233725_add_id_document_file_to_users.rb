class AddIdDocumentFileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :id_document_file, :text
  end
end
