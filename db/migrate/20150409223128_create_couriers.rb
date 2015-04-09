class CreateCouriers < ActiveRecord::Migration
  def change
    create_table :couriers do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :company_name
      t.string :address
      t.string :nit_company_number
      t.string :id_document_type
      t.string :id_document_number

      t.timestamps
    end
  end
end
