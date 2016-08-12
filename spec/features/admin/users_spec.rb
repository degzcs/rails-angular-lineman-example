require 'spec_helper'

describe 'all test the user view', :js do
  context 'logging in' do
    before :each do
      visit '/admin/login'
      user = AdminUser.find_by email: 'soporte@trazoro.co'
      login_as(user, scope: :admin_user)
    end
    it 'visit user view and create new user' do
      visit '/admin'
      expect(page).to have_content 'Logout'
      find('#users').click # link header of users
      expect(page).to have_content 'Users'
      find('.action_item').click # button new user
      expect(page).to have_content 'New User'
      select('authorized_producer', from: 'user_role_ids')
      # fill_in 'Correo*', with: Faker::Internet.email
      # fill_in 'Oficina', with: 'user@example.com'
      # fill_in 'Rucom', with: 'user@example.com'
    end
    #   it "signs me in" do
    #   visit '/admin/login'
    #   within('#login') do
    #     fill_in 'Email*', :with => 'user@example.com'
    #     fill_in 'Password*', :with => 'password'
    #   end
    #   click_button 'Login'
    #   expect(page).to have_content 'Logout'
    # end
  end
end
