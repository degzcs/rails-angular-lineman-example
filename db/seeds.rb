if Rails.env.production?
  # TODO: use the DANE xls file to import thsi states and cities
  puts 'Creating population centers ...'
  state = FactoryGirl.create(:state, name: 'Antíoquia', code: '05')
  city = FactoryGirl.create(:city, name: 'Medellín', state: state, code: '001' )
  population_center = FactoryGirl.create(:population_center, name: 'Trazoro', city: city, code: '<000></000>')

  puts 'Creating basic users ...'
  begin
  AdminUser.create(email:'soporte@trazoro.co',password: 'A7l(?/]03tal9-%g4', password_confirmation: 'A7l(?/]03tal9-%g4')
  FactoryGirl.create :user, email: 'diego.gomez@trazoro.co', password: 'A7l(?/]03tal9-%g4', password_confirmation: 'A7l(?/]03tal9-%g4' , population_center: population_center
  FactoryGirl.create :user, email: 'jesus.munoz@trazoro.co', password: 'A7l(?/]03tal9-%g4', password_confirmation: 'A7l(?/]03tal9-%g4', population_center: population_center
  rescue
    puts 'There is something wrong!!!'
  end


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
    puts 'creating rucoms ...'
    rucoms = FactoryGirl.create_list(:rucom, 10)

    puts 'creating extenal_users ...'
    rucoms.each do|rucom|
      FactoryGirl.create(:external_user,personal_rucom: rucom, population_center: population_center, available_credits: rand(2000 .. 50000)) #, population_center_id: population_center.id)
    end

    puts 'creating barequeros and chatarreros providers ...'
    bc_rucoms = FactoryGirl.create_list(:rucom, 10, provider_type: ["Barequero", "Chatarrero"].sample)
    bc_rucoms.each do|rucom|
      FactoryGirl.create(:external_user,personal_rucom: rucom, population_center_id: PopulationCenter.first.id, available_credits: rand(2000 .. 50000))
    end

    puts 'creating pawnshops providers ...'
    ccv_rucoms = FactoryGirl.create_list(:rucom, 10, provider_type: 'Casa de Compraventa')
    ccv_rucoms.each do|rucom|
      FactoryGirl.create(:external_user,personal_rucom: rucom, population_center_id: PopulationCenter.first.id, available_credits: rand(2000 .. 50000))
    end
  end

end
