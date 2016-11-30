class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :name
      t.string :initials
      t.float :porcent
      t.references :puc_account, index: true

      t.timestamps
    end
  end
end
