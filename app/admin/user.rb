ActiveAdmin.register User do
  menu priority: 3, label: 'Usuarios'

  permit_params :email, :first_name, :last_name , :document_number , :document_expedition_date , :phone_number , :address, :password, :document_number_file, :rut_file, :mining_register_file, :photo_file, :chamber_commerce_file, :company_info_id, :rucom_id, :population_center_id


  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :document_number
    column :document_expedition_date
    column :phone_number
    column :address
    column :password
    actions
  end

  filter :rucom
  filter :email
  filter :first_name
  filter :last_name
  filter :document_number
  filter :document_expedition_date
  filter :phone_number

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :document_number
      f.input :document_expedition_date
      f.input :phone_number
      f.input :address
      f.input :password
      f.input :document_number_file, :as => :file
      f.input :rut_file, :as => :file
      f.input :mining_register_file, :as => :file
      f.input :photo_file, :as => :file
      f.input :chamber_commerce_file, :as => :file
      f.input :company_info
      f.input :rucom
      f.input :population_center
    end
    f.actions
  end

end
