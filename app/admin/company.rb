#  nit_number           :string(255)
#  name                 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country              :string(255)
#  email                :string(255)
#  phone_number         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  provider_id          :integer
#

#
#
# NOTE: It is not used anymore, check if it could de deleted
#
#

ActiveAdmin.register Company do
  menu false #priority: 4, label: 'Compañias'

  permit_params :nit_number, :name, :city, :state , :country , :legal_representative  , :email , :phone_number ,:chamber_of_commerce_file, :rut_file

  controller do
    # This code is evaluated within the controller class
    def company
      # Instance method
      Company.find(params[:id])
    end
  end

  sidebar "Lista de oficinas", only: [:show, :edit] do

    ul do
      company.offices.each do |office|
        li link_to office.name, admin_company_office_path(company,office)
      end
    end
    a link_to "Crear oficina", new_admin_company_office_path(company), class: "create_child_button"
    a link_to "Ver lista con detalles", admin_company_offices_path(company)
  end

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

  form partial: 'form'

  form do |f|
    f.inputs "Informacion de compañia" do
      f.input :nit_number , label: "NIT"
      f.input :name, label: "Nombre"
      f.input :legal_representative, label: "Representante legal", :collection => User.all.map{ |u| ["#{u.profile.first_name} - #{u.profile.last_name}", u.id]}
      f.input :country, label: "Pais", collection: Country.all.map{|country| country.name}
      f.input :state, label: "Departamento", collection: State.all.map{|state| state.name}
      f.input :city, label: "Ciudad", collection: City.all.map{|city| city.name}
      f.input :email , label: "Email compañia"
      f.input :phone_number, label:"Telefono"
      f.input :chamber_of_commerce_file, :as => :file, label: "PDF Camara de comercio", :hint => link_to(image_tag(f.object.chamber_of_commerce_file.try(:preview).try(:url)),f.object.chamber_of_commerce_file.url, :target => "_blank" )
      f.input :rut_file, :as => :file, label: "PDF RUT", :hint => link_to(image_tag(f.object.rut_file.try(:preview).try(:url)),f.object.rut_file.url, :target => "_blank" )
      # f.input :mining_register_file, :as => :file, label: "PDF Registro minero", :hint => link_to(image_tag(f.object.mining_register_file.try(:preview).try(:url)),f.object.mining_register_file.url, :target => "_blank" )
    end
    f.actions
  end

  show do
    attributes_table do
      row :nit_number , label: "NIT"
      row :name, label: "Nombre"
      row :country, label: "Pais"
      row :city, label: "Ciudad"
      row :state, label: "Departamento"
      row :legal_representative , label: "Representante legal"
      row :phone_number, label: "Telefono"
      row :chamber_of_commerce_file , label: "PDF camara de comercio"do|u|
        link_to(image_tag(u.chamber_of_commerce_file.try(:preview).try(:url)),u.chamber_of_commerce_file.url, :target => "_blank" )
      end
      row :rut_file , label: "PDF Rut"do|u|
        link_to(image_tag(u.rut_file.try(:preview).try(:url)),u.rut_file.url, :target => "_blank" ) if u.rut_file
      end
      row :mining_register_file , label: "PDF registro minero"do|u|
        link_to(image_tag(u.mining_register_file.try(:preview).try(:url)),u.mining_register_file.url, :target => "_blank" )
      end
      row :rucom ,label: "Rucom de compañia"
    end
    #active_admin_comments
  end
end