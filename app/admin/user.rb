ActiveAdmin.register User do
  menu priority: 6, label: 'Usuarios'

  permit_params :id, :email, :office_id, :password, :password_confirmation, :rucom, :alegra_sync, role_ids: [], profile_attributes: [:first_name, :last_name, :document_number, :phone_number, :address, :rut_file, :photo_file, :mining_authorization_file, :id_document_file, :legal_representative, :nit_number, :city_id, :user_id], setting_attributes: [:alegra_token, :fine_gram_value]

  config.clear_action_items!

  action_item :new_rucom, only: :index do
    link_to 'Crear proveedor autorizado', new_admin_rucom_path
  end

  action_item :new_user, only: :index do
    link_to 'Crear comercializador', new_admin_user_path
  end

  # @params params [ Hash ]
  controller do
    def update
      user = User.find(params[:id])
      ActiveRecord::Base.transaction do
        service_ids = params[:user][:available_trazoro_service_id]
        service_ids.reject!{ |item| item.empty? } if service_ids.present?
        if user.trader? && user.profile.legal_representative? && service_ids.present?
          user.setting.update_attributes(permitted_params[:user][:setting_attributes])
          user.setting.trazoro_service_ids = service_ids
          user.save!
        end
        user.update_attributes(permitted_params[:user].except(:profile_attributes, :setting_attributes))
        user.profile.update_attributes(permitted_params[:user][:profile_attributes])
        user.user_complete? unless user.completed?
      end
      redirect_to admin_user_path(user)
    end
  end

  # @params params [ Hash ]
  controller do
    def create
      user = User.new(permitted_params[:user])
      user.save
      user.user_complete?
      if user.errors.full_messages.present?
        redirect_to admin_users_path, notice: user.errors.full_messages
      else
        redirect_to admin_users_path, notice: 'El usuario se ha creado satisfactoriamente'
      end
    end
  end

  member_action :synchronize do
    user = ::User.find(params[:id])
    user.syncronize_with_alegra!(APP_CONFIG[:ALEGRA_SYNC])
    if user.reload.alegra_sync
      redirect_to admin_users_path, notice: 'Sincronizado!'
    else
      redirect_to admin_users_path, alert: 'No fue Sincronizado!'
    end
  end

  # new and edit
  form do |f|
    if f.object.errors.size >= 1
      f.inputs 'Errors' do
        f.object.errors.full_messages.join("<br>").html_safe
      end
    end
    f.inputs 'User' do
      if params[:action] == 'edit'
        columns "Este Usuario Cuenta Actualmente Con #{user.office ? 'Rucom de empresa' : 'Rucom personal'}: #{user.rucom.name} - Numero: #{user.rucom.rucom_number}"
        f.input :roles, label: 'Rol'
      end
      f.input :email, label: 'Correo'
      if params[:action] == 'new'
        f.input :roles, label: 'Rol', collection: Role.all.map { |r| ["#{r.name if r.name == 'trader'}", r.id] }
        f.input :office, label: 'oficina', :collection => Office.all.map { |o| ["#{o.company.name if o.company} - #{o.name}", o.id] }
      end
      unless user.authorized_provider?
        f.input :password, label: 'Password (Minimo 8 caracteres)', :if => f.object.authorized_provider?
        f.input :password_confirmation, label: 'password_confirmation'
      end
    end
    f.inputs 'User Details' do
      f.has_many :profile do |p|
        p.input :first_name, label: 'Nombre'
        p.input :last_name, label: 'Apellido'
        p.input :document_number, label: 'Numero de documento'
        p.input :phone_number, label: 'Numero telefonico'
        p.input :address, label: 'Direccion'
        p.input :photo_file, :as => :file, label: 'Foto Usuario', :hint => image_tag(p.object.photo_file.try(:thumb).try(:url))
        p.input :rut_file, :as => :file, label: 'PDF Rut'
        p.input :mining_authorization_file, :as => :file, label: 'PDF registro minero'
        p.input :id_document_file, :as => :file, label: 'PDF Document_id'
        # p.input :legal_representative, label: 'Representante Legal' # This is obsolete for the moment
        p.input :nit_number, label: 'nit_number'
        p.input :city, label: 'Ciudad'
      end
    end
    if params[:action] == 'edit' && user.trader? && user.profile.legal_representative?
        f.inputs 'Configuración de Usuario' do
          f.input :trazoro_services, as: :check_boxes, collection: AvailableTrazoroService.all.map { |o| ["#{o.name}", o.id, checked: f.object.setting.trazoro_service_ids.include?(o.id)]}
          f.has_many :setting, heading: '' do |s|
            s.input :alegra_token, label: 'Token alegra', hint: 'Este tóken tiene que ser conseguido desde Alegra para la facturación'
            s.input :fine_gram_value, label: 'Valor del gramo fino', hint: 'Este valor sera tenido encuenta sobre la configuración general'
          end
        end
    end
    f.actions
  end

  # index
  index do
    selectable_column
    id_column
    column :email
    column(:first_name) do |user|
      user.profile.first_name
    end
    column(:document_number) do |user|
      user.profile.document_number
    end
    column(:roles) do |user|
      user.roles.map(& :name)
    end
    column :rucom
    column(:legal_representative) do |user|
      user.profile.legal_representative?
    end
    column :alegra_sync
    column :registration_state
    actions defaults: true, dropdown: true do |user|
      item 'Sincronizar', synchronize_admin_user_path(user)
    end
  end

  # filters
  filter :email
  filter :profile_first_name, :as => :string
  filter :profile_document_number, :as => :string
  filter :profile_phone_number, :as => :string
  filter :roles
  filter :profile_legal_representative, :as => :string

  # form partial: 'form'
  # show
  show do
    attributes_table do
      row :email
      row :company, label: 'Compañia' do |u|
        u.company ? u.company.name : 'Ninguna'
      end
      row :office, label: 'Sucursal' do |u|
        u.office ? u.office.name : '--'
      end
      row :rucom do |u|
        link_to "#{u.office ? 'Rucom de empresa' : 'Rucom personal'}: #{u.rucom.name} - Numero: #{u.rucom.rucom_number}", admin_rucom_path(u.rucom.id)
      end
      row :roles do |u|
        u.roles.map(& :name)
      end
    end
    panel 'User profile' do
      attributes_table_for user.profile do
        row :first_name, label: 'Nombre'
        row :last_name, label: 'Apellido'
        row :document_number, label: 'Numero de documento'
        row :nit_number, label: 'nit_number'
        row :phone_number, label: 'Numero telefonico'
        row :address, label: 'Direccion'
        row :city, label: 'Ciudad'
        row :photo_file, label: 'Foto usuario' do |u|
          image_tag u.photo_file.try(:thumb).try(:url), class: 'photo-user'
        end
        row :rut_file, label: 'PDF Rut' do |u|
          link_to(image_tag(u.rut_file.try(:preview).try(:url)), u.rut_file.url, :target => '_blank') if u.rut_file
        end
      end
    end
    if user.trader? && user.profile.legal_representative?
      panel 'Servicios adquiridos por este usuario' do
        attributes_table_for user.profile do
          row 'Nombre Servicios' do |p|
            p.setting.trazoro_services.present? ? p.setting.trazoro_services.map(& :name).join(',  ') : 'Este usuario no cuenta aun con servicios trazoro'
          end
        end
      end
      panel 'Configuración de usuario' do
        attributes_table_for user.setting do
          row :alegra_token, label: 'Token Alegra'
          row :fine_gram_value, label: 'Valor gramo fino'
        end
      end
    end
    # active_admin_comments
  end
end
