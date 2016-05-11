  # TODO: use the DANE xls file to import thsi states and cities
puts 'Creating population centers ...'

  importer = Importers::DaneCsvImporter.new
  importer.call(file_path: '../res/legal/codigos-departamentos-municipios-dane-v1.0.csv' )
  country = Country.find_by(name: 'COLOMBIA')
  city = City.find_by(name: 'MEDELLIN')
  state = State.find_by(name: 'ANTIOQUIA')
  population_center = PopulationCenter.find_or_create_by(name: 'Distrito de la innovación', city: city, code: '000')
begin
  # TODO: add the real files to this company (rut, nit, etc.)
  company = FactoryGirl.create(:company,
                                name: 'Trazoro',
                                city: city.name,
                                state: state.name,
                                country: country.name,
                                legal_representative: 'Diego Caicedo',
                                id_type_legal_rep: 'NIT',
                                id_number_legal_rep: '123456789',
                                nit_number: '123456789',
                                email: 'soport@trazoro.co',
                                phone_number: '3004322618',
                              )
rescue
  company = Company.find_by(nit_number: '123456789')
  puts 'There was something wrong!'
end

begin
  office = company.offices.first
rescue => e
  puts "There is not Office or the Campany was no created properly. ERROR: #{ e }"
end

puts 'Creating basic users ...'
begin
  AdminUser.create(email:'soporte@trazoro.co',password: 'A7l(?/]03tal9-%g4', password_confirmation: 'A7l(?/]03tal9-%g4')
  FactoryGirl.create(:user,
        first_name: 'Tech',
        last_name: 'Trazoro',
        email: 'tech@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4' ,
        population_center: population_center,
        office: office,)

  FactoryGirl.create(:user,
        first_name: 'Diego',
        last_name: 'Gomez',
        email: 'diego.gomez@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4' ,
        population_center: population_center,
        office: office,)

  FactoryGirl.create(:user,
        first_name: 'Jesus',
        last_name: 'Munoz',
        email: 'jesus.munoz@trazoro.co',
        password: 'A7l(?/]03tal9-%g4',
        password_confirmation: 'A7l(?/]03tal9-%g4',
        population_center: population_center,
        office: office,)
rescue => e
  puts "There is something wrong!!!, perhaps the users were already created. ERROR: #{ e }"
end

puts 'Associating trazoro users ...'
# Add to the trazoro Office
trazoro_users = User.where(email: ['diego.gomez@trazoro.co', 'jesus.munoz@trazoro.co', 'tech@trazoro.co'])
trazoro_users.update_all(office_id: office.id)

unless Rails.env.production?
  # Rucoms for User as clients
   # {:idrucom=>"8704649770448",
   # :rucom_record=>"1405799154764",
   # :name=>"Andy Schulist",
   # :status=>"active",
   # :mineral=>"ORO",
   # :location=>"Hansenbury",
   # :subcontract_number=>"37-0221157",
   # :mining_permit=>"6789268195393",
   # #:updated_at=>Sun, 07 Jun 2015 21:44:41 UTC +00:00,
   # :provider_type=>"Barequero",
   # :num_rucom=>"0828372893637",
   # :id=>315,
   # :rucomeable_type=>nil,
   # :rucomeable_id=>nil}

  # puts 'creating purchases ...'
  # User.all.each do |user|
  #   FactoryGirl.create(:purchase, user_id: user.id, provider_id: Provider.last.id, gold_batch_id: FactoryGirl.create(:gold_batch).id )
  # end

  if ENV['FAKE_INFO'] == 'yes'
    puts 'Adding fake information ...'
    puts 'Creating rucoms ...'
    rucoms = FactoryGirl.create_list(:rucom, 10)

    puts 'Creating extenal_users ...'
    rucoms.each do|rucom|
      FactoryGirl.create(:external_user,personal_rucom: rucom, population_center: population_center, available_credits: rand(2000 .. 50000)) #, population_center_id: population_center.id)
    end

    puts 'Creating barequeros and chatarreros providers ...'
    bc_rucoms = FactoryGirl.create_list(:rucom, 10, provider_type: ["Barequero", "Chatarrero"].sample)
    bc_rucoms.each do|rucom|
      FactoryGirl.create(:external_user,personal_rucom: rucom, population_center_id: PopulationCenter.first.id, available_credits: rand(2000 .. 50000))
    end

    puts 'Creating pawnshops providers ...'
    ccv_rucoms = FactoryGirl.create_list(:rucom, 10, provider_type: 'Casa de Compraventa')
    ccv_rucoms.each do|rucom|
      FactoryGirl.create(:external_user,personal_rucom: rucom, population_center_id: PopulationCenter.first.id, available_credits: rand(2000 .. 50000))
    end
  end
  puts 'Done!'
end
