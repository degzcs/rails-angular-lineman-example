puts 'creating roles...'
Role::TYPES.each do |role_name|
  Role.create name: role_name
end

puts 'Create basic settings ...'
settings = Settings.instance
settings.data = { monthly_threshold: 30, fine_gram_value: 1000, vat_percentage: 16, fixed_sale_agreetment: "fixed sale agreetment text", habeas_data_agreetment: "habeas agreetment text", ros_threshold: 2000000 }
settings.save!

puts 'Creating cities and states ...'

if ENV['CREATE_LOCATIONS'] == 'yes'
  importer = Importers::DaneCsvImporter.new
  importer.call(file_path: File.join(Rails.root, 'spec', 'support', 'csvs', 'codigos-departamentos-municipios-dane-v1.0.csv'))
end

city = City.find_by(name: 'MEDELLIN')

begin
  # TODO: add the real files to this company (rut, nit, etc.)
  company = FactoryGirl.create(:company,
                                name: 'MinTrace Colombia SAS',
                                city: city,
                                legal_representative: nil,
                                nit_number: '900848984',
                                email: 'soport@trazoro.co',
                                phone_number: '3004322618',
                                address: 'carrera 44 # 19 A 20',
                              )
  legal_representative = FactoryGirl.create(:user, :with_profile, :with_trader_role,
        first_name: 'Diego',
        last_name: 'Caicedo',
        email: 'dcm@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4' ,
        city: city,
        office: company.main_office,
        legal_representative: true)
  company.update_column(:legal_representative_id, legal_representative.id)
  company.complete!
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

  FactoryGirl.create(:user, :with_profile, :with_trader_role,
        first_name: 'Tech',
        last_name: 'Trazoro',
        email: 'tech@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4' ,
        city: city,
        office: office,)

  FactoryGirl.create(:user, :with_profile, :with_trader_role,
        first_name: 'Diego',
        last_name: 'Gomez',
        email: 'diego.gomez@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4' ,
        city: city,
        office: office,)

  FactoryGirl.create(:user, :with_profile, :with_trader_role,
        first_name: 'Santiago',
        last_name: 'Lopez',
        email: 'santiago.lopez@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4',
        city: city,
        office: office,)
rescue => e
  puts "There is something wrong!!!, perhaps the users were already created. ERROR: #{ e }"
end

puts 'Associating trazoro users ...'
# Add to the trazoro Office
trazoro_users = User.where(email: ['diego.gomez@trazoro.co', 'tech@trazoro.co', 'dcm@trazoro.co', 'santiago.lopez@trazoro.co'])
trazoro_users.update_all(office_id: office.id)

puts 'Setting user roles ...'
trade_role = Role.find_by(name: 'trader')
trazoro_users.each do |user|
  begin
    user.roles << trade_role unless user.roles.include?(trade_role)
    user.complete! if user.registration_state = 'initialized'
  rescue => e
    puts "ERROR: #{ e }"
  end
end

puts 'Associating user settings to trazoro dcm user legal representative'
begin
  legal_representative = User.find_by(email: 'dcm@trazoro.co')
  raise 'don\'t create user setting for user dcm legal representative' unless legal_representative
  unless legal_representative.setting
    usr_setting = FactoryGirl.build(:user_setting, profile_id: legal_representative.profile.id)
    usr_setting.save
    puts 'user settings associated successfully!'
  end
  puts 'Creating Basic Trazoro Service'
  trazoro_service = FactoryGirl.create(:available_trazoro_service, name: 'Compra de Oro', credits: 1.0, reference: 'buy_gold')
  legal_representative.setting.trazoro_services << trazoro_service
rescue => e
  puts "There is something wrong!!!, without a user setting will be errors in the sale transactions. ERROR: #{ e }"
end
