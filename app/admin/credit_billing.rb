ActiveAdmin.register CreditBilling do

  menu priority: 8, label: 'Facturacion de Usuarios'

  # Member actions , This methods create new actions under the admin credit billing controller
  # every action has a route od /admin/credit_bilings/:id/<Action> and it will render a template
  # under the dir app/views/admin/credit_billings/<action>

  member_action :update do
    @credit_billing = CreditBilling.find(params[:id])
    response = @credit_billing.update_attributes(discount_percentage: permitted_params[:credit_billing][:discount_percentage])
    message = if response
      'Credit billing was successfully updated.'
    else
      @credit_billing.errors.full_messages
    end
    redirect_to admin_credit_billings_path, notice: message
  end

  # Updates a credit billing with paid to true, and add a new available_credit value to the user
  member_action :update_payment, method: :patch do
    @credit_billing = CreditBilling.find(params[:id])

    credit_billing_params = params.require(:credit_billing).permit(:paid, :payment_date, :discount_percentage)
    credit_billing_acceptance = CreditBilling::Acceptance.new
    response = credit_billing_acceptance.call(
      credit_billing: @credit_billing,
      new_credit_billing_values: credit_billing_params,
      )
    message = if response[:success]
                "La factura fue marcada como pagada satisfactoriamente"
              else
                "ERRORES: #{ response[:errors] }"
              end
    redirect_to admin_credit_billings_path, notice: message
  end

  # Renders a template where the admin can select the date when the credit billing was paid
  member_action :mark do
    @credit_billing = CreditBilling.find(params[:id])
  end

  # Incharge to create an invoice into Alegra plataform.
  member_action :create_invoice do
    @credit_billing = CreditBilling.find(params[:id])
    @user = @credit_billing.user
    service = Alegra::Credits::CreateInvoice.new
    response = service.call(payment_method: 'card', credit_billing: @credit_billing)
    if response[:success]
      redirect_to new_billing_admin_credit_billing_path(@credit_billing.id), notice: "La fatura a sido creada satisfactoriamente"
    else
      redirect_to new_billing_admin_credit_billing_path(@credit_billing.id), notice: response[:errors].join(" ")
    end
  end

  # Renders a template where the user can select a discount percentage value
  member_action :edit_discount do
    @credit_billing = CreditBilling.find(params[:id])
    @user = @credit_billing.user
  end

  # Sends an email to the user with the information about the credit billing
  member_action :send_billing do
    @credit_billing = CreditBilling.find(params[:id])
    @user = @credit_billing.user
    service = Alegra::Credits::SendEmailInvoice.new
    response = service.call(credit_billing: @credit_billing)
    if response[:success]
      redirect_to admin_credit_billings_path, notice: "El correo ha sido enviado a #{ @credit_billing.user.email } satisfactoriamente"
    else
      redirect_to new_billing_admin_credit_billing_path(@credit_billing.id), notice: response[:errors].join(" ")
    end
  end

  # renders a template with info that will be sended to the user about the credit billing
  member_action :new_billing do
    @credit_billing = CreditBilling.find(params[:id])
    @user = @credit_billing.user
  end

  actions :index , :edit , :update , :lock , :billing

  permit_params :paid, :payment_date, :discount_percentage

  index do
    selectable_column
    id_column
    column "Usuario", :user
    column "Creditos solicitados", :quantity
    column "Valor credito",:unit_price
    column "%Descuento",:discount_percentage
    column("Estado",:paid) do |credit|
      credit.paid? ? status_tag( "Pagado", :ok ) : status_tag( "Sin Pago" )
    end
    column "Fecha de pago",:payment_date
    column("TOTAL", :total_amount)

    actions defaults: false, dropdown: true do |credit_billing|
      if credit_billing.paid?
        item 'Factura pagada!'
      else
        item "Descuento", edit_discount_admin_credit_billing_path(credit_billing.id)
        item "Facturar" , new_billing_admin_credit_billing_path(credit_billing.id)
        item 'Marcar como pagado' , mark_admin_credit_billing_path(credit_billing.id)
      end
    end

  end

  filter :user_email ,:as => :string
  filter :quantity
  filter :unit_price
  filter :paid
  filter :payment_date
  filter :discount_percentage


  form do |f|
    f.inputs "Detalles de Factura" do
      f.input :discount_percentage, label: "% Descuento"
      f.input :paid ,label: "Marcar como pagada"
      f.input :payment_date , as: :datepicker, datepicker_options: { max_date: "D" }, label: "Fecha de pago"
    end
    f.actions
  end

end
