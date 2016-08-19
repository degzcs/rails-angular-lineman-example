# require 'spec_helper'

# describe 'all test the user view', js: true do
#   before :each do
#     visit '/admin/login'
#     user = AdminUser.find_by email: 'soporte@trazoro.co'
#     login_as(user, scope: :admin_user)
#   end
#   it 'visit user view and create new user' do
#     expected_office = Office.first
#     expected_city = City.first
#     expected_response = {
#       email: 'prueba@test.com',
#       password: '12345678',
#       office: expected_office.name,
#       profile: {
#         first_name: 'prueba',
#         last_name: 'test',
#         document_number: '10610022201020',
#         phone_number: '5555555',
#         address: 'calle #prueba',
#         rut_file: "#{ Rails.root }/spec/support/pdfs/rut_file.pdf",
#         photo_file: "#{ Rails.root }/spec/support/images/photo_file.png",
#         mining_authorization_file: "#{ Rails.root }/spec/support/pdfs/mining_register_file.pdf",
#         id_document_file: "#{ Rails.root }/spec/support/pdfs/document_number_file.pdf",
#         nit_number: '123456789000',
#         city: expected_city.name
#       }
#     }
#     visit '/admin'
#     find('#users').click # link header of users
#     find('.action_item').click # button new user
#     select('authorized_producer', from: 'user_role_ids')
#     fill_in 'Correo*', with: expected_response[:email]
#     select(expected_response[:office], from: 'user_office_id')
#     # select('Empresa falsa # 0', from: 'user_rucom')
#     fill_in 'Password (Minimo 8 caracteres)*', with: expected_response[:password]
#     fill_in 'password_confirmation', with: expected_response[:password]
#     find('#new_user > fieldset:nth-child(3) > ol > li > a').click # button add new profile
#     fill_in 'Nombre*', with: expected_response[:profile][:first_name]
#     fill_in 'Apellido*', with: expected_response[:profile][:last_name]
#     fill_in 'Numero de documento*', with: expected_response[:profile][:document_number]
#     fill_in 'Numero telefonico*', with: expected_response[:profile][:phone_number]
#     fill_in 'Direccion*', with: expected_response[:profile][:address]
#     attach_file('user_profile_attributes_photo_file', expected_response[:profile][:photo_file])
#     attach_file('user_profile_attributes_rut_file', expected_response[:profile][:rut_file])
#     attach_file('user_profile_attributes_mining_authorization_file', expected_response[:profile][:mining_authorization_file])
#     attach_file('user_profile_attributes_id_document_file', expected_response[:profile][:id_document_file])
#     fill_in 'nit_number', with: expected_response[:profile][:nit_number]
#     select(expected_response[:profile][:city], from: 'user_profile_attributes_city_id')
#     click_button('Create User')

#     last_user = User.order(:created_at).last.as_json(include: :profile).with_indifferent_access
#     expect(page).to have_content 'User was successfully created.'

#     expect(last_user[:email]).to eq expected_response[:email]
#     expect(last_user[:office_id]).to eq expected_office.id
#     expect(last_user[:profile][:city_id]).to eq expected_city.id

#     expected_response[:profile].except(:rut_file, :photo_file, :mining_authorization_file, :id_document_file, :city).each do |key, value|
#       expect(last_user['profile'][key]).to eq value
#     end

#     expect(last_user[:profile][:rut_file]['url']).to match(/rut_file.pdf/)
#     expect(last_user[:profile][:photo_file]['url']).to match(/photo_file.png/)
#     expect(last_user[:profile][:mining_authorization_file]['url']).to match(/mining_register_file.pdf/)
#     expect(last_user[:profile][:id_document_file]['url']).to match(/document_number_file.pdf/)
#   end

#   it 'Edit User' do
#     user = User.find_by(email: 'santiago.lopez@trazoro.co')
#     expected_response = {
#       address: 'calle #40',
#       phone_number: '5555555-5'
#     }
#     visit '/admin/users/'
#     within("#user_#{user.id}") do
#       click_link('Edit')
#     end
#     # update user with new info
#     fill_in 'user_profile_attributes_phone_number', with: ' '
#     fill_in 'user_profile_attributes_phone_number', with: expected_response[:phone_number]
#     fill_in 'user_profile_attributes_address', with: ' '
#     fill_in 'user_profile_attributes_address', with: expected_response[:address]
#     click_button('Update User')

#     expect(user.reload.profile.address).to eq expected_response[:address]
#     expect(user.profile.phone_number).to eq expected_response[:phone_number]
#   end

#   it 'Show User' do
#     user = User.find_by(email: 'dcm@trazoro.co')
#     visit '/admin/users/'
#     within("#user_#{user.id}") do
#       click_link('View')
#     end
#     expect(page).to have_content 'dcm@trazoro.co'
#     expect(page).to have_content 'Diego'
#   end

#   it 'Destroy User' do
#     user = User.find_by(email: 'santiago.lopez@trazoro.co')
#     visit '/admin/users/'
#     within("#user_#{user.id}") do
#       click_link('Delete')
#     end
#     expect(page).to have_content 'User was successfully destroyed.'
#   end

#   it 'Test filters' do
#     visit '/admin/users/'
#     expect(page).to have_content 'Users'
#     within('#filters_sidebar_section') do
#       fill_in 'q_email', with: 'trazoro.co'
#       click_button('Filter')
#       fill_in 'q_profile_first_name', with: 'Diego'
#       click_button('Filter')
#     end
#     expect(page).to have_content 'Email contains trazoro.co'
#     expect(page).to have_content 'Profile First Name contains Diego'
#     find('#users').click
#     within('#filters_sidebar_section') do
#       select('trader', from: 'q_role_ids')
#       click_button('Filter')
#     end
#     expect(page).to have_content 'Roles ID equals 1'
#     expect(page).to have_content 'trader'
#   end

#   it 'Test button Batch Actions' do
#     visit '/admin/users/'
#     check('batch_action_item_3')
#     click_on('Batch Actions')
#     click_on('Delete Selected')
#     click_on('OK')
#     expect(page).to have_content 'Successfully destroyed 1 user'
#   end
# end
