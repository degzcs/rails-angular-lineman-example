puts 'creating roles...'
Role::TYPES.each do |role_name|
  Role.create name: role_name
end

puts 'Create basic settings ...'
settings = Settings.instance
settings.data = { monthly_threshold: 30, fine_gram_value: 1000, vat_percentage: 16 }
settings.save!

puts 'Creating cities and states ...'

if ENV['CREATE_LOCATIONS'] == 'yes'
  importer = Importers::DaneCsvImporter.new
  importer.call(file_path: File.join(Rails.root, 'spec', 'support', 'csvs', 'codigos-departamentos-municipios-dane-v1.0.csv'))
end

city = City.find_by(name: 'MEDELLIN')

begin
  # TODO: add the real files to this company (rut, nit, etc.)
  legal_representative = FactoryGirl.build(:user, :with_profile,
        first_name: 'Diego',
        last_name: 'Caicedo',
        email: 'dcm@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4' ,
        city: city,
        office: nil,
        legal_representative: true)
  company = FactoryGirl.create(:company,
                                name: 'MinTrace Colombia SAS',
                                city: city,
                                legal_representative: legal_representative,
                                nit_number: '900848984',
                                email: 'soport@trazoro.co',
                                phone_number: '3004322618',
                                address: 'carrera 44 # 19 A 20',
                              )
rescue => e
  company = Company.find_by(nit_number: '900848984')
  puts "There was something wrong!. ERROR: #{ e }"
end

begin
  office = company.offices.first
  office.update_column :address, 'Calle 67 # 52 -20'
rescue => e
  puts "There is not Office or the Company was not created properly. ERROR: #{ e }"
end

puts 'Creating basic users ...'
begin
  AdminUser.create(
    email:'soporte@trazoro.co',
    password: 'A7l(?/]03tal9-%g4',
    password_confirmation: 'A7l(?/]03tal9-%g4',
    )

  FactoryGirl.create(:user, :with_profile,
        first_name: 'Tech',
        last_name: 'Trazoro',
        email: 'tech@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4' ,
        city: city,
        office: office,)

  FactoryGirl.create(:user, :with_profile,
        first_name: 'Diego',
        last_name: 'Gomez',
        email: 'diego.gomez@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4' ,
        city: city,
        office: office,)

  FactoryGirl.create(:user, :with_profile,
        first_name: 'Santigo',
        last_name: 'Lopez',
        email: 'santigo.lopez@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4',
        city: city,
        office: office,)
rescue => e
  puts "There is something wrong!!!, perhaps the users were already created. ERROR: #{ e }"
end

puts 'Associating trazoro users ...'
# Add to the trazoro Office
trazoro_users = User.where(email: ['diego.gomez@trazoro.co', 'jesus.munoz@trazoro.co', 'tech@trazoro.co', 'dcm@trazoro.co'])
trazoro_users.update_all(office_id: office.id)

puts 'Setting user roles ...'
trade_role = Role.find_by(name: 'trader')
trazoro_users.each do |user|
  begin
    user.roles << trade_role
  rescue => e
    puts "ERROR: #{ e }"
  end
end

puts 'Done!'
