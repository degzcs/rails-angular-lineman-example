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
  menu priority: 5, label: 'Sucursales'

  permit_params :name, :company_id
  belongs_to :company

  controller do
    # This code is evaluated within the controller class

    def office
      # Instance method
      Office.find(params[:id])
    end
  end

  sidebar "Lista de usuarios", only: [:show, :edit] do

    ul do
      office.users.each do |user|
        li link_to user.profile.first_name, admin_user_path(user)
      end
    end

    # a link_to "Crear Usuario", new_admin_office_user_path(office), class: "create_child_button"
    # a link_to "Ver lista con detalles", admin_office_users_path(office)

  end


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