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
  menu priority: 5, label: 'Facturacion de Usuarios'

  actions :index, :show , :edit , :update
  permit_params :payment_flag, :payment_date, :discount_percentage

  index do
    selectable_column
    id_column
    column "Usuario", :user
    column "Creditos solicitados", :unit
    column "Valor credito",:per_unit_value 
    column "% Descuento",:discount_percentage
    column("Estado",:payment_flag) do |credit| 
      credit.payment_flag? ? status_tag( "Pagado", :ok ) : status_tag( "Sin Pago" )
    end
    column "Fecha de pago",:payment_date 
    column("TOTAL", :total_amount) do |credit|
      credit.total_amount - credit.discount
    end
    
    actions
  end

  filter :user_email ,:as => :string
  filter :unit
  filter :per_unit_value
  filter :payment_flag
  filter :payment_date
  filter :discount_percentage


  form do |f|
    f.inputs "Detalles de Factura" do
      f.input :payment_flag ,label: "Factura Pagada"
      f.input :payment_date , as: :datepicker, datepicker_options: { max_date: "D" }
      f.input :discount_percentage
    end
    f.actions
  end

end
