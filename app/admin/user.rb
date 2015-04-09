ActiveAdmin.register User do
  menu priority: 3, label: 'Usuarios'

  permit_params :email, :first_name, :last_name , :document_number , :document_expedition_date , :phone_number , :password

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :document_number
    column :document_expedition_date
    column :phone_number
    column :password
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :document_number
  filter :document_expedition_date
  filter :phone_number
  filter :password

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :document_number
      f.input :document_expedition_date
      f.input :phone_number
      f.input :password
    end
    f.actions
  end

end
