ActiveAdmin.register Rucom do
  actions :index, :show
  permit_params :idrucom, :rucom_record, :name , :status , :mineral , :location , :subcontract_number , :mining_permit , :updated_at

  index do
    selectable_column
    id_column
    column :idrucom
    column :rucom_record
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
  filter :rucom_record
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
      f.input :rucom_record
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
