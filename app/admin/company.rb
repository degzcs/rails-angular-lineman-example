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

ActiveAdmin.register Company do
  menu priority: 4, label: 'Compañias'

  actions :index, :show, :edit, :create, :new, :update
  permit_params :nit_number, :name, :city_id, :legal_representative, :email, :phone_number, :chamber_of_commerce_file, :rut_file

  controller do
    # This code is evaluated within the controller class
    def company
      # Instance method
      Company.find(params[:id])
    end
  end

  # overwrite controller create for create a company using the scraper
  controller do
    def create
      parameters = permitted_params[:company]
      params_values = { rol_name: parameters['name'], id_type: 'NIT', id_number: parameters['nit_number'] }
      response = RucomServices::Synchronize.new(params_values).call
      if response.response[:errors][0]
        redirect_to admin_companies_path, notice: 'A ocurrido un error'
      else
        redirect_to admin_companies_path
      end
    end
  end

  sidebar 'Lista de oficinas', only: [:show, :edit] do
    ul do
      company.offices.each do |office|
        li link_to office.name, admin_company_office_path(company, office)
      end
    end
    a link_to 'Crear oficina', new_admin_company_office_path(company), class: 'create_child_button'
    a link_to 'Ver lista con detalles', admin_company_offices_path(company)
  end

  index do
    selectable_column
    id_column
    column :nit_number
    column :name
    column :city
    column :legal_representative
    column :email
    actions
  end

  filter :nit_number
  filter :name
  filter :city

  form partial: 'form'

  form do |f|
    f.inputs 'Informacion de compañia' do
      if params[:action] == 'new'
        f.input :name, label: 'Rol', collection: %w(Comercializadores)
        f.input :nit_number, label: 'NIT'
      else
        f.input :nit_number, label: 'NIT'
        f.input :name, label: 'Nombre'
        f.input :legal_representative, label: 'Representante legal', :collection => User.all.map { |u| ["#{u.profile.first_name} - #{u.profile.last_name}", u.id] }
        f.input :city, label: 'Ciudad'
        f.input :email, label: 'Email compañia'
        f.input :phone_number, label: 'Telefono'
        f.input :address, label: 'Direccion'
        f.input :chamber_of_commerce_file, :as => :file, label: 'PDF Camara de comercio', :hint => link_to(image_tag(f.object.chamber_of_commerce_file.try(:preview).try(:url)), f.object.chamber_of_commerce_file.url, :target => '_blank')
        f.input :rut_file, :as => :file, label: 'PDF RUT', :hint => link_to(image_tag(f.object.rut_file.try(:preview).try(:url)), f.object.rut_file.url, :target => '_blank')
        f.input :mining_register_file, :as => :file, label: 'PDF Registro minero', :hint => link_to(image_tag(f.object.mining_register_file.try(:preview).try(:url)), f.object.mining_register_file.url, :target => '_blank')
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :nit_number, label: 'NIT'
      row :name, label: 'Nombre'
      row :city, label: 'Ciudad'
      row :address, label: 'Direccion'
      row :state, label: 'Departamento'
      row :legal_representative, label: 'Representante legal'
      row :phone_number, label: 'Telefono'
      row :chamber_of_commerce_file, label: 'PDF camara de comercio' do |u|
        link_to(image_tag(u.chamber_of_commerce_file.try(:preview).try(:url)), u.chamber_of_commerce_file.url, :target => '_blank')
      end
      row :rut_file, label: 'PDF Rut' do |u|
        link_to(image_tag(u.rut_file.try(:preview).try(:url)), u.rut_file.url, :target => '_blank') if u.rut_file
      end
      row :mining_register_file, label: 'PDF registro minero' do |u|
        link_to(image_tag(u.mining_register_file.try(:preview).try(:url)), u.mining_register_file.url, :target => '_blank')
      end
      row :rucom, label: 'Rucom de compañia'
    end
    # active_admin_comments
  end
end
