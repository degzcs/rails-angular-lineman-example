require 'spec_helper'

describe 'all test the orders view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  it 'Order Show' do
    purchase_order = create(:purchase, :with_origin_certificate_file)
    visit '/admin/orders'
    within("#order_#{purchase_order.id}") do
      click_link('View')
    end
    expect(page).to have_content "Order ##{purchase_order.id}"
  end
end
