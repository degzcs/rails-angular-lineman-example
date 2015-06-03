ActiveAdmin.register User do

  menu priority: 3, label: 'Usuarios'

  permit_params :email, :first_name, :last_name , :document_number , :document_expedition_date , :phone_number , :address, :document_number_file, :rut_file, :mining_register_file, :photo_file, :office_id, :population_center_id, :password , :password_confirmation

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
    column("Tipo usuario",:external) do |credit| 
      !credit.external? ? status_tag( "trazoro", :ok ) : status_tag( "externo", :warn )
    end
    actions
  end

  #filter :rucom
  filter :email
  filter :first_name
  filter :last_name
  filter :document_number
  filter :document_expedition_date
  filter :phone_number
  filter :external


  form partial: 'form'


  # form do |f|
  #   if f.object.errors.size >= 1
  #     f.inputs "Errors" do
  #       f.object.errors.full_messages.join('|')
  #     end
  #   end

  #   f.inputs "User Details" do
  #     f.input :email 
  #     f.input :first_name , label: "Nombre"
  #     f.input :last_name, label: "Apellido"
  #     f.input :document_number , label: "Numero de documento"
  #     f.input :document_expedition_date, label: "fecha de expedicion" , label: "Fecha de expedicion documento" , start_year: Date.today.year - 70
  #     f.input :phone_number, label: "Numero telefonico"
  #     f.input :address, label: "Direccion"
  #     f.input :photo_file, :as => :file , label: "Foto Usuario" , :hint => image_tag(f.object.photo_file.thumb.url)
  #     f.input :document_number_file, :as => :file , label: "PDF cedula"
  #     f.input :rut_file, :as => :file, label: "PDF Rut"
  #     f.input :mining_register_file, :as => :file, label: "PDF registro minero"
  #     f.input :office, label: "Sucursal"
  #     f.input :population_center, label: "Centro poblacional"
  #     f.input :password, label: "Password (Minimo 8 caracteres)", :if => f.object.external
  #   end
  #   f.actions
  # end

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
        link_to(image_tag(u.document_number_file.preview.url),u.document_number_file.url, :target => "_blank" )
      end
      row :rut_file , label: "PDF Rut"do|u|
        link_to(image_tag(u.rut_file.preview.url),u.rut_file.url, :target => "_blank" ) if u.rut_file
      end
      row :mining_register_file , label: "PDF registro minero"do|u|
        link_to(image_tag(u.mining_register_file.preview.url),u.mining_register_file.url, :target => "_blank" )
      end

      row :company , label: "Compañia" do|u|
        u.company ? u.company.name : "Ninguna"
      end
      row :office , label: "Sucursal" do|u|
        u.office ? u.office.name : "--"
      end
      row :rucom do|u|
        link_to "#{u.office ? 'Rucom de empresa' : 'Rucom personal'}: #{u.rucom.name} - Numero: #{u.rucom.num_rucom}", admin_rucom_path(u.rucom.id)
      end
      row :population_center, label: "Centro poblado"  do|u|
        u.population_center.name
      end 
    end
    active_admin_comments
  end

end
