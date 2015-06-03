ActiveAdmin.register Rucom do
  menu priority: 4, label: 'Rucoms'

  actions :index, :show
  permit_params :idrucom, :num_rucom, :rucom_record, :provider_type, :name , :status , :mineral , :location , :subcontract_number , :mining_permit , :updated_at

  # renders a template where the admin can register a company using a rucom
  member_action :create_company do
    @rucom = Rucom.find(params[:id])
  end


  index do
    selectable_column
    id_column
    #column :idrucom
    column :num_rucom
    column :rucom_record
    column :provider_type
    column :name
    column :status
    column :mineral
    column :location
    column :subcontract_number
    column :mining_permit
    column :updated_at

    column("Estado",:rucom_status) do |rucom| 
      if rucom.rucomeable 
        if rucom.rucomeable_type == "User"
          rucom.rucomeable.external ? status_tag( "Usuario Externo", :warn) : status_tag( "Usuario", :ok )
        else
          status_tag( "Compañia", :ok ) 
        end
      else
        status_tag( "Sin usar" )
      end
    end


    actions defaults: false, dropdown: true do |rucom|
      if rucom.rucomeable
        item "Ver Compañia", admin_company_path(rucom.rucomeable_id) if rucom.rucomeable_type == "Company"
        item "Ver Usuario", admin_user_path(rucom.rucomeable_id) if rucom.rucomeable_type == "User"
      else
        item "Crear Compañia", create_company_admin_rucom_path(rucom.id) 
        item "Crear Usuario", create_company_admin_rucom_path(rucom.id)
      end
    end
  end

  #filter :idrucom
  filter :num_rucom
  filter :rucom_record
  filter :provider_type
  filter :name
  filter :status
  filter :mineral
  filter :location
  filter :subcontract_number
  filter :mining_permit
  filter :updated_at

  form do |f|
    f.inputs "Rucom Details" do
      #f.input :idrucom
      f.input :num_rucom
      f.input :rucom_record
      f.input :provider_type
      f.input :name
      f.input :status
      f.input :mineral
      f.input :location
      f.input :subcontract_number
      f.input :mining_permit
      f.input :updated_at
    end
    f.actions
  end

end
