require 'spec_helper'

describe 'all test the purchase view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  after :each do
    user = User.last
    user.destroy! if user.present?
    office = Office.last.destroy!
    office.destroy! if office.present?
    company = Company.last
    company.destroy! if company.present?
    purchase = Purchase.last
    purchase.destroy! if purchase.present?
  end

  it 'Purchase Show' do
    purchase = create(:purchase, :with_origin_certificate_file)
    visit '/admin/purchases'
    within("#purchase_#{purchase.id}") do
      click_link('View')
    end
    expect(page).to have_content "Purchase ##{purchase.id}"
  end
end
