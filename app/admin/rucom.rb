ActiveAdmin.register Rucom do
  menu priority: 3, label: 'Rucoms'
  # This view will do deprecated
  actions :index, :show, :edit, :create, :new, :update
  permit_params :id, :rucom_number, :name, :original_name, :minerals, :location, :status, :provider_type, :rucomeable_id, :rucomeable_type, :updated_at, :created_at

  # renders a template where the admin can register a company using a rucom
  member_action :new_company do
    @company = Company.new
    @rucom = Rucom.find(params[:id])
  end

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
          rucom.rucomeable.external ? status_tag('Usuario Externo', :warn) : status_tag('Usuario', :ok)
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
        item 'Registrar Compañia', new_company_admin_rucom_path(rucom.id)
      end
    end
  end

  filter :rucom_number
  filter :name
  filter :minerals
  filter :location
  filter :status
  filter :provider_type

  form do |f|
    f.inputs 'Rucom Details' do
      f.input :rucom_number
      f.input :name
      f.input :original_name
      f.input :minerals
      f.input :location
      f.input :status
      f.input :provider_type
    end
    f.actions
  end
end
