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

  member_action :mark do
    @credit_billing = CreditBilling.find(params[:id])
  end

  member_action :edit_discount do
    @credit_billing = CreditBilling.find(params[:id])
  end

  member_action :send_billing do
    credit_billing = CreditBilling.find(params[:id])
    CreditBillingMailer.credit_billing_email(credit_billing).deliver
    redirect_to admin_credit_billings_path, notice: "El correo ha sido enviado a #{credit_billing.user.email} satisfactoriamente" 
  end
  
  member_action :new_billing do
    @credit_billing = CreditBilling.find(params[:id])
    @user = @credit_billing.user
  end

  actions :index , :edit , :update , :lock , :billing

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
    column("TOTAL", :total_amount)

    actions defaults: false, dropdown: true do |credit_billing|
      if credit_billing.payment_flag
        item 'Factura pagada!'
      else
        item "Descuento", edit_discount_admin_credit_billing_path(credit_billing.id)
        item "Facturar" , new_billing_admin_credit_billing_path(credit_billing.id) 
        item 'Marcar como pagado' , mark_admin_credit_billing_path(credit_billing.id) 
      end
    end

  end

  filter :user_email ,:as => :string
  filter :unit
  filter :per_unit_value
  filter :payment_flag
  filter :payment_date
  filter :discount_percentage


  form do |f|
    f.inputs "Detalles de Factura" do
      f.input :discount_percentage, label: "% Descuento"
      f.input :payment_flag ,label: "Marcar como pagada"
      f.input :payment_date , as: :datepicker, datepicker_options: { max_date: "D" }, label: "Fecha de pago"
    end
    f.actions
  end

end
