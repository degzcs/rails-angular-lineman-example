# == Schema Information
#
# Table name: credit_billings
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  unit                :integer
#  per_unit_value      :float
#  payment_flag        :boolean
#  payment_date        :datetime
#  discount_percentage :float
#  created_at          :datetime
#  updated_at          :datetime
#

ActiveAdmin.register CreditBilling do
  actions :index, :show , :edit , :update
  permit_params :payment_flag, :payment_date, :discount_percentage

  index do
    selectable_column
    id_column
    column :user
    column :unit
    column :per_unit_value
    column :payment_flag
    column :payment_date
    column :discount_percentage
    actions
  end

  filter :user
  filter :unit
  filter :per_unit_value
  filter :payment_flag
  filter :payment_date
  filter :discount_percentage


  form do |f|
    f.inputs "Credit Billing Details" do
      f.input :payment_flag
      f.input :payment_date
      f.input :discount_percentage
    end
    f.actions
  end

end
