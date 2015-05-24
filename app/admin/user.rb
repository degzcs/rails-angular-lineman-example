ActiveAdmin.register User do
  menu priority: 3, label: 'Usuarios'

  permit_params :email, :first_name, :last_name , :document_number , :document_expedition_date , :phone_number , :address, :document_number_file, :rut_file, :mining_register_file, :photo_file, :chamber_commerce_file, :company_info_id, :rucom_id, :population_center_id, :password


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
    actions
  end

  #filter :rucom
  filter :email
  filter :first_name
  filter :last_name
  filter :document_number
  filter :document_expedition_date
  filter :phone_number

  form do |f|
    if f.object.errors.size >= 1
      f.inputs "Errors" do
        f.object.errors.full_messages.join('|')
      end
    end

    f.inputs "User Details" do
      f.input :email 
      f.input :first_name , label: "Nombre"
      f.input :last_name, label: "Apellido"
      f.input :document_number , label: "Numero de documento"
      f.input :document_expedition_date, label: "fecha de expedicion" , label: "Fecha de expedicion documento" , start_year: Date.today.year - 70
      f.input :phone_number, label: "Numero telefonico"
      f.input :address, label: "Direccion"
      f.input :photo_file, :as => :file , label: "Foto Usuario" , :hint => image_tag(f.object.photo_file.thumb.url)
      f.input :document_number_file, :as => :file , label: "PDF cedula"
      f.input :rut_file, :as => :file, label: "PDF Rut"
      f.input :mining_register_file, :as => :file, label: "PDF registro minero"
      f.input :chamber_commerce_file, :as => :file, label: "PDF camara de comercio"
      f.input :company, label: "Compañia"
      f.input :rucom_id, label: "Id Rucom (Revisar campo 'Id' en la Tabla de Rucoms)" ,as: :number
      f.input :population_center, label: "Centro poblacional"
      f.input :password, label: "Password (Minimo 8 caracteres)"
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :first_name, label: "Nombre"
      row :last_name, label: "Apellido"
      row :document_number, label: "Numero de documento"
      row :document_expedition_date, label: "Fecha de expedicion"
      row :phone_number , label: "Numero telefonico"
      row :address, label: "Direccion"
      row :photo_file, label: "Foto usuario" do|u|
        image_tag u.photo_file.thumb.url , class: "photo-user"
      end
      row :document_number_file , label: "PDF cedula"do|u|
        link_to "archivo PDF", u.document_number_file.url
      end
      row :rut_file , label: "PDF Rut"do|u|
        link_to "archivo PDF",u.rut_file.url if u.rut_file
      end
      row :mining_register_file , label: "PDF registro minero"do|u|
        link_to "archivo PDF",u.mining_register_file.url
      end
      row :chamber_commerce_file , label: "PDF camara de comercio"do|u|
        link_to "archivo PDF",u.chamber_commerce_file.url
      end
      row :company , label: "Compañia"do|u|
        u.company.name
      end
      row :rucom do|u|
        link_to "Rucom: #{u.rucom.name}", admin_rucom_path(u.rucom.id)
      end
      row :population_center, label: "Centro poblado"  do|u|
        u.population_center.name
      end 
    end
    active_admin_comments
  end

end
