# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

ActiveAdmin.register Office do
  menu priority: 2, label: 'Sucursales'

  permit_params :name, :company_id

  index do
    selectable_column
    id_column
    column :name
    column :company 
    actions
  end

  filter :name
  filter :company
  

  form do |f|
    f.inputs "Informacion de sucursal" do
      f.input :name , label: "Nombre"
      f.input :company, label: "Compañia"
    end
    f.actions
  end

end