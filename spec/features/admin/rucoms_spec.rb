require 'spec_helper'

describe 'all test the purchase view', :js do
  before :each do
    admin_user = AdminUser.find_by(email: 'soporte@trazoro.co')
    login_as(admin_user, scope: :admin_user)
  end

  it 'New Rucom' do
  end

  it 'Edit Rucom' do
  end

  it 'Test dropdown action' do
  end
end
