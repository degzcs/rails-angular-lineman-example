require 'spec_helper'

describe 'all test the credit_billings view', :js do
  let(:user) { create(:user, :with_profile,:with_company, :with_trader_role, first_name: 'Alan', last_name: 'Britho', alegra_id: 1, legal_representative: true) }

  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  after :each do
    user = User.last
    user.destroy! if user.present?
    credit_billing = CreditBilling.last
    credit_billing.destroy! if credit_billing.present?
  end

  it 'should apply a discount to the invoice' do
    expected_response = 10.0
    credit_billing = create(:credit_billing, user: user, paid: false, payment_date: nil, total_amount: 1000000)
    visit '/admin/credit_billings'
    within("#credit_billing_#{credit_billing.id}") do
      click_on('Actions')
      click_on('Descuento')
    end
    expect(page).to have_content 'Seleccione el porcentaje que desea descontar de esta factura (0 - 100)'
    fill_in 'credit_billing_discount_percentage', with: expected_response
    click_button('Guardar')
    expect(credit_billing.reload.discount_percentage).to eq expected_response
    expect(page).to have_content 'Credit billing was successfully updated.'
  end

  it 'should create an invoice into Alegra' do
      credit_billing = create(:credit_billing, user: user, paid: false, payment_date: nil, total_amount: 1000000)
      visit '/admin/credit_billings'
      within("#credit_billing_#{credit_billing.id}") do
        click_on('Actions')
        click_on('Facturar')
      end
      VCR.use_cassette('alegra_create_credits_invoice_as_admin') do
        expect(page).to have_content 'Datos de Transaccion'
        click_link('Crear Factura en Alegra')
      end
      # click_link('Cancelar Envio de factura')
      page.execute_script 'window.confirm = function () { return true }'
      expect(page).to have_content "La fatura a sido creada satisfactoriamente"
      expect(credit_billing.reload.invoiced).to eq true
  end

  # TODO: use the alegra send mail feature instead of this implementation
  it 'should send the invoice  by email' do
     # VCR.use_cassette('alegra_send_credits_invoice_by_email_as_admin') do
      credit_billing = create(:credit_billing, user: user, paid: false, payment_date: nil, total_amount: 1000000)
      visit '/admin/credit_billings'
      within("#credit_billing_#{credit_billing.id}") do
        click_on('Actions')
        click_on('Facturar')
      end
      expect(page).to have_content 'Datos de Transaccion'
      click_link('Enviar Factura a usuario')
      # click_link('Cancelar Envio de factura')
      page.execute_script 'window.confirm = function () { return true }'
      expect(page).to have_content "El correo ha sido enviado a #{credit_billing.user.email} satisfactoriamente"
    # end
  end

  it 'should mark the invoice as paid out' do
    # VCR.use_cassette('alegra_update_credits_invoice_to_paid') do
      expected_response = {
        payment_date: 'Fri, 19 Aug 2016 09:00:00 UTC +00:00',
        paid: true
      }
      credit_billing = create(:credit_billing, user: user, paid: false, payment_date: nil, total_amount: 1000000)
      visit '/admin/credit_billings'
      within("#credit_billing_#{credit_billing.id}") do
        click_on('Actions')
        click_on('Marcar como pagado')
      end
      expect(page).to have_content 'Ingrese la fecha en la que el usuario pago esta factura'
      fill_in 'credit_billing_payment_date', with: '2016/08/19, 09:00 AM'
      click_button('Marcar como pagado')
      page.execute_script 'window.confirm = function () { return true }'
      expect(credit_billing.reload.payment_date).to eq expected_response[:payment_date]
      expect(credit_billing.reload.paid).to eq expected_response[:paid]
      expect(page).to have_content 'La factura fue marcada como pagada satisfactoriamente'
    # end
  end
end
