class CreateCompanyInfos < ActiveRecord::Migration
  def change
    create_table :company_infos do |t|
      t.string :nit_number
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.string :legal_representative
      t.string :id_type_legal_rep 
      t.string :email
      t.string :phone_number
      t.timestamps
    end
  end
end
