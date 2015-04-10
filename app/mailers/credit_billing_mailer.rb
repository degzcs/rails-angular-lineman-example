class CreditBillingMailer < ActionMailer::Base
  default from: "trazoro-admin@trazoro.com"

  def credit_billing_email(credit_billing)
    @credit_billing = credit_billing
    @user = credit_billing.user
    mail(to: @user.email,subject: "Factura para Pago de Creditos Trazoro")
  end
end
