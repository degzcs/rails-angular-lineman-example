ActiveAdmin.register Rucom do
  menu priority: 3, label: 'Rucoms'

  actions :index, :show, :edit, :create, :new, :update
  permit_params :id, :rucom_number, :name, :original_name, :minerals, :location, :status, :provider_type, :rucomeable_id, :rucomeable_type, :updated_at, :created_at

  # renders a template where the admin can register a company using a rucom
  # member_action :new_company do
  #   @company = Company.new
  #   @rucom = Rucom.find(params[:id])
  # end

  member_action :create_company, method: :post do
    rucom = Rucom.find(params[:rucom_id])
    company_registration_service = Company::Registration.new

    company_params = params.require(:company).permit(:nit_number, :name, :city_id, :email, :phone_number, :address, :chamber_of_commerce_file, :rut_file, :mining_register_file)

    legal_representative_params = params[:company].require(:legal_representative_attributes).permit!
    response = company_registration_service.call(
      company_data: company_params,
      legal_representative_data: legal_representative_params,
      rucom: rucom
      )
    if response[:success]
      redirect_to(admin_company_path(company_registration_service.company), :notice => 'La compañia a sido creada correctamente')
    else
      render :new_company, alert: 'No se pudo crear la compañia!'
    end
  end

  index do
    selectable_column
    id_column
    column :rucom_number
    column :name
    column :minerals
    column :location
    column :status
    column :provider_type
    column :updated_at

    column('Estado', :rucom_status) do |rucom|
      if rucom.rucomeable
        if rucom.rucomeable_type == 'User'
          status_tag(rucom.rucomeable_type, :warn)
          # status_tag(rucom.rucomeable.roles[0][:name], :warn)
        else
          status_tag('Compañia', :ok)
        end
      else
        status_tag('Sin usar')
      end
    end

    actions defaults: false, dropdown: true do |rucom|
      if rucom.rucomeable
        item 'Ver Compañia', admin_company_path(rucom.rucomeable_id) if rucom.rucomeable_type == 'Company'
        item 'Ver Usuario', admin_user_path(rucom.rucomeable_id) if rucom.rucomeable_type == 'User'
      else
        # item 'Registrar Compania', new_company_admin_rucom_path(rucom.id)
      end
    end
  end

  filter :rucom_number
  filter :name
  filter :minerals
  filter :location
  filter :status
  filter :provider_type

  # overwrite controller create for create a Rucom using the scraper
  controller do
    def create
      parameters = permitted_params[:rucom]
      params_values = { rol_name: parameters['name'], id_type: parameters['provider_type'], id_number: parameters['rucom_number'] }
      response = RucomServices::Synchronize.new(params_values).call
      if response.response[:errors][0] == "Sincronize.call: error => The rucom dosen't exist for this id_number: #{params_values[:id_number]}"
        redirect_to admin_rucoms_path, notice: 'Rucom No Existe en la pagina ANM'
      else
        redirect_to admin_rucoms_path
      end
    end
  end

  form do |f|
    f.inputs 'Rucom Details' do
      if params[:action] == 'new'
        f.input :name, label: 'Rol', collection: %w(Barequero)
        f.input :provider_type, label: 'Tipo Identificacion', collection: %w(CEDULA)
        f.input :rucom_number, label: 'Numero Identificacion'
      else
        f.input :rucom_number
        f.input :name
        f.input :original_name
        f.input :minerals
        f.input :location
        f.input :status
        f.input :provider_type
      end
    end
    f.actions
  end
end
