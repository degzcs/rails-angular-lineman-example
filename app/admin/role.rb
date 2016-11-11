ActiveAdmin.register Role do
  # has_and_belongs_to_many :user--> profile

  menu priority: 4, label: 'Roles'

  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  form do |f|
    f.inputs 'Adding a new role' do
      f.input :name
    end
    f.actions
  end
end
