ActiveAdmin.register User do
  menu priority: 6, label: 'Usuarios'

  permit_params :id, :email, :office_id, :password, :password_confirmation, :external, :rucom, role_ids:  [], profile_attributes: [:first_name, :last_name, :document_number, :phone_number, :address, :rut_file, :photo_file, :mining_authorization_file, :id_document_file, :legal_representative, :nit_number, :city_id, :user_id]

  # overwrite controller update to perform upgrade Rucom.
  controller do
    def update
      user = User.find(params[:id])
      if params[:user][:rucom].present?
        rucom_id = params[:user].delete(:rucom)
        if user.rucom.present?
          user.rucom.update_attributes(rucomeable_id: nil)
          rucom = Rucom.find_by_id(rucom_id)
          rucom.update_attributes(rucomeable: user)
        else
          rucom = Rucom.find_by_id(rucom_id)
          rucom.update_attributes(rucomeable: user)
        end
      end
      ActiveRecord::Base.transaction do
        user.update_attributes(permitted_params[:user].except(:profile_attributes))
        user.profile.update_attributes(permitted_params[:user][:profile_attributes])
      end
      redirect_to admin_user_path(user)
    end
  end
  # overwrite controller create to create a user with an associated Rucom.
  controller do
    def create
      if permitted_params[:user][:rucom].blank?
        super
      elsif params[:user][:rucom].present?
        rucom_id = permitted_params[:user][:rucom]
        new_hash = permitted_params[:user].except(:rucom)
        new_hash[:personal_rucom] = Rucom.find(rucom_id)
        user = User.new(new_hash)
        user.save!
        redirect_to admin_users_path
      end
    end
  end

  # new and edit
  form do |f|
    if f.object.errors.size >= 1
      f.inputs 'Errors' do
        f.object.errors.full_messages.join('|')
      end
    end
    f.inputs 'User' do
      if params[:action] == 'edit'
        columns "Este Usuario Cuenta Actualmente Con #{user.office ? 'Rucom de empresa' : 'Rucom personal'}: #{user.rucom.name} - Numero: #{user.rucom.rucom_number}"
      end
      f.input :roles, label: 'Rol'
      f.input :email, label: 'Correo'
      f.input :office, label: 'oficina', :collection => Office.all.map { |o| ["#{o.company.name if o.company} - #{o.name}", o.id] }
      unless user.has_office?
        # TDDO: Encontrar la manera de que el desplegable seleccione  el rucom asociado al usuario que se esta editando. Tener en cuenta que la relacion User con Rucom es polimorfica.
        f.input :rucom, label: 'Rucom', :collection => Rucom.all.map { |rucom| [rucom.name, rucom.id] }
      end
      unless user.external
        f.input :password, label: 'Password (Minimo 8 caracteres)', :if => f.object.external
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
        p.input :legal_representative, label: 'Representante Legal'
        p.input :nit_number, label: 'nit_number'
        p.input :city, label: 'Ciudad'
      end
    end
    f.actions
  end

  # index
  index do
    selectable_column
    id_column
    column :email
    column(:first_name) { |user|
      user.profile.first_name
    }
    column(:document_number) { |user|
      user.profile.document_number
    }
    column(:phone_number) { |user|
      user.profile.phone_number
    }
    column(:roles) { |user|
      user.roles.map(& :name)
    }
    actions
  end

  # filters
  filter :email
  filter :profile_first_name, :as => :string
  filter :profile_document_number, :as => :string
  filter :profile_phone_number, :as => :string
  filter :roles

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
    # active_admin_comments
  end
end
