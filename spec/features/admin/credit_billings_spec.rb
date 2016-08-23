require 'spec_helper'

describe 'all test the credit_billings view', :js do
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

  it 'action discount test' do
    expected_response = 10.0
    credit_billing = create(:credit_billing, payment_flag: false, payment_date: nil, total_amount: 1000000)
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

  it 'action invoice test' do
    credit_billing = create(:credit_billing, payment_flag: false, payment_date: nil, total_amount: 1000000)
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
  end

  it 'action mark as paid out test' do
    expected_response = {
      payment_date: 'Fri, 19 Aug 2016 09:00:00 UTC +00:00',
      payment_flag: true
    }
    credit_billing = create(:credit_billing, payment_flag: false, payment_date: nil, total_amount: 1000000)
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
    expect(credit_billing.reload.payment_flag).to eq expected_response[:payment_flag]
    expect(page).to have_content 'La factura fue marcada como pagada satisfactoriamente'
  end
end
