class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :file
      t.string :type
      t.string :documentable_id
      t.string :documentable_type

      t.timestamps null: false

    end
    add_index :documents, :documentable_id
  end
end
