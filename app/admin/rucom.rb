ActiveAdmin.register Rucom do
  actions :index, :show
  permit_params :idrucom, :num_rucom, :rucom_record, :provider_type, :name , :status , :mineral , :location , :subcontract_number , :mining_permit , :updated_at

  index do
    selectable_column
    id_column
    column :idrucom
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
    actions
  end

  filter :idrucom
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
      f.input :idrucom
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
