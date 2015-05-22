#  nit_number           :string(255)
#  name                 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country              :string(255)
#  legal_representative :string(255)
#  id_type_legal_rep    :string(255)
#  email                :string(255)
#  phone_number         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  provider_id          :integer
#  id_number_legal_rep  :string(255)
#
ActiveAdmin.register Company do
  menu priority: 2, label: 'Compañias'

  permit_params :nit_number, :name, :city, :state , :country , :legal_representative , :id_type_legal_rep , :email , :phone_number ,:id_number_legal_rep

  index do
    selectable_column
    id_column
    column :nit_number
    column :name 
    column :city
    column :state
    column :legal_representative
    column :email
    actions
  end

  filter :nit_number
  filter :name
  filter :city
  filter :state

  form do |f|
    f.inputs "Informacion de compañia" do
      f.input :nit_number , label: "NIT"
      f.input :name, label: "Nombre"
      f.input :country, label: "Pais"
      f.input :city, label: "Ciudad"
      f.input :state, label: "Departamento"
      f.input :legal_representative, label: "Representante legal"
      f.input :id_number_legal_rep, label: "Id representante legal"
      f.input :email , label: "Email compañia"
      f.input :phone_number, label:"Telefono"
    end
    f.actions
  end

end