describe 'the signin process' do
  it 'signs me in' do
    visit '/admin/login'
    within("#login") do
      fill_in 'Email', :with => 'soporte@trazoro.co'
      fill_in 'Password', :with => 'A7l(?/]03tal9-%g4'
    end
    click_button 'Login'
    expect(page).to have_content 'Signed in successfully.'
  end
end
