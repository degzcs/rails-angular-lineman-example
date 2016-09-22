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
  permit_params :id, :nit_number, :name, :city_id, :legal_representative, :email, :phone_number, :chamber_of_commerce_file, :rut_file, :address, :mining_register_file

  controller do
    # This code is evaluated within the controller class
    def company
      # Instance method
      Company.find(params[:id])
    end
  end

  # @params permitted_params [ Hash ]
  # @return [ Hash ] with the success or errors
  # overwrite controller create for create a company using the scraper
  controller do
    def create
      parameters = permitted_params[:company]
      params_values = { rol_name: parameters['name'], id_type: parameters['address'], id_number: parameters['nit_number'] }
      response = RucomServices::Synchronize.new(params_values).call
      if response.response[:errors][0] == "Sincronize.call: error => The rucom dosen't exist for this id_number: #{params_values[:id_number]}"
        redirect_to admin_companies_path, notice: 'Rucom No Existe en la pagina ANM'
      elsif response.scraper.virtus_model.present? || response.scraper.is_there_rucom.present?
        redirect_to admin_companies_path, notice: 'La compañia y el rucom de esta se han creado correctamente'
      elsif response.response[:errors][0] == "Sincronize.call: error => create_rucom: [\"RucomService::Scraper.call: Net::ReadTimeout\"]"
        redirect_to admin_companies_path, notice: 'Se ha agotado el tiempo de espera!'
      elsif response.scraper.virtus_model.nil? && response.scraper.is_there_rucom == false
        redirect_to admin_companies_path, notice: 'la compañia ya Existe!'
      end
    end
  end

  # @params params [ Hash ]
  # @return [ Hash ] with the success or errors
  # overwrite controller update for update a company using the service registration
  controller do
    def update
      company_registration_service = Company::Registration.new
      id = params[:id]
      company_params = params.require(:company).permit(:id, :nit_number, :name, :city_id, :email, :phone_number, :address, :chamber_of_commerce_file, :rut_file, :mining_register_file)
      company_params[:id] = id
      legal_representative_params = params[:company].require(:legal_representative_attributes).permit!
      response = company_registration_service.call(
        company_data: company_params,
        legal_representative_data: legal_representative_params
      )
      if response[:errors].present? && response[:success] == false
        redirect_to edit_admin_company_path, notice: response[:errors]
      elsif response[:success]
        redirect_to admin_companies_path, notice: 'La compañia se actualizo correctamente'
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
    column :rucom
    actions
  end

  filter :nit_number
  filter :name
  filter :city

  form partial: 'form'

  form do |f|
    if f.object.errors.size >= 1
      f.inputs 'Errors' do
        f.object.errors.full_messages.join("<br>").html_safe
      end
    end
    if params[:action] == 'new'
      f.inputs 'Informacion de compañia' do
        f.input :name, label: 'Rol', collection: %w(Comercializadores)
        f.input :address, label: 'Tipo Identificacion', collection: %w(NIT)
        f.input :nit_number, label: 'Numero Identificacion'
      end
    end
    if params[:action] == 'edit'
      f.inputs 'Informacion Compañia' do
        f.input :nit_number, label: 'NIT'
        f.input :name, label: 'Nombre'
        f.input :city, label: 'Ciudad'
        f.input :email, label: 'Email compañia'
        f.input :phone_number, label: 'Telefono'
        f.input :address, label: 'Direccion'
        f.input :chamber_of_commerce_file, :as => :file, label: 'PDF Camara de comercio', :hint => link_to(image_tag(f.object.chamber_of_commerce_file.try(:preview).try(:url)), f.object.chamber_of_commerce_file.url, :target => '_blank')
        f.input :rut_file, :as => :file, label: 'PDF RUT', :hint => link_to(image_tag(f.object.rut_file.try(:preview).try(:url)), f.object.rut_file.url, :target => '_blank')
        f.input :mining_register_file, :as => :file, label: 'PDF Registro minero', :hint => link_to(image_tag(f.object.mining_register_file.try(:preview).try(:url)), f.object.mining_register_file.url,:target => '_blank')
      end
      f.inputs 'Informacion Representante legal' do
        user = f.object.legal_representative || User.new
        user.build_profile unless user.profile.present?
        f.semantic_fields_for :legal_representative, user do |u|
          u.semantic_fields_for :profile_attributes, user.profile do |p|
            u.input :email, label: 'email'
            u.input :password, label: 'password'
            u.input :password_confirmation, label: 'password_confirmation'
            p.input :first_name, label: 'Nombre'
            p.input :last_name, label: 'Apellido'
            p.input :document_number, label: 'Numero de documento'
            p.input :phone_number, label: 'Numero telefonico'
            p.input :address, label: 'Direccion'
            p.input :photo_file, :as => :file, label: 'Foto Usuario', :hint => image_tag(p.object.photo_file.try(:thumb).try(:url))
            p.input :rut_file, :as => :file, label: 'PDF Rut'
            p.input :mining_authorization_file, :as => :file, label: 'PDF registro minero'
            p.input :id_document_file, :as => :file, label: 'PDF Document_id'
            p.input :legal_representative, label: 'Representante Legal'
            p.input :nit_number, label: 'nit_number'
            p.input :city, label: 'Ciudad'
          end
        end
      end
    end
    f.actions
  end

  show do
    attributes_table do
      company_id = params[:id]
      company = Company.find(company_id)
      if company.registration_state == 'completed'
        row :nit_number, label: 'NIT'
        row :name, label: 'Nombre'
        row :city, label: 'Ciudad'
        row :email, label: 'Email Compañia'
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
      else
        row :nit_number, label: 'NIT'
      end
      row :rucom, label: 'Rucom de compañia'
    end
    # active_admin_comments
  end
end
