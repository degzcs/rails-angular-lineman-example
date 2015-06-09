# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Rails.env.production?

  AdminUser.create(email:'admin@example.com',password:'password')
  puts 'creating rucoms ...'
  rucoms = FactoryGirl.create_list(:rucom, 10)

  # Rucoms for User as clients
   {:idrucom=>"8704649770448",
 :rucom_record=>"1405799154764",
 :name=>"Andy Schulist",
 :status=>"active",
 :mineral=>"ORO",
 :location=>"Hansenbury",
 :subcontract_number=>"37-0221157",
 :mining_permit=>"6789268195393",
 #:updated_at=>Sun, 07 Jun 2015 21:44:41 UTC +00:00,
 :provider_type=>"Barequero",
 :num_rucom=>"0828372893637",
 :id=>315,
 :rucomeable_type=>nil,
 :rucomeable_id=>nil}

  # puts 'creating purchases ...'
  # User.all.each do |user|
  #   FactoryGirl.create(:purchase, user_id: user.id, provider_id: Provider.last.id, gold_batch_id: FactoryGirl.create(:gold_batch).id )
  # end

  puts 'creating population centers ...'
  states = FactoryGirl.create_list(:state, 10)
  states.each do|state|
    cities = FactoryGirl.create_list(:city, 5, state_id: state.id, state_code: state.state_code)
    cities.each do|city|
      FactoryGirl.create_list(:population_center, 5, city_id: city.id, city_code: city.city_code)
    end
  end

  puts 'creating extenal_users ...'
  rucoms.each do|rucom|
    FactoryGirl.create(:external_user,personal_rucom: rucom, population_center_id: PopulationCenter.first.id, available_credits: rand(2000 .. 50000)) #, population_center_id: population_center.id)
  end

  puts 'creating normal users ...'
  begin
  FactoryGirl.create :user, email: 'diego@trazoro.com', password: '123456', password_confirmation: '123456' , population_center_id: PopulationCenter.first.id
  FactoryGirl.create :user, email: 'jesus@trazoro.com', password: '123456', password_confirmation: '123456', population_center_id: PopulationCenter.first.id
  FactoryGirl.create :user, email: 'camilo@trazoro.com', password: '123456', password_confirmation: '123456', population_center_id: PopulationCenter.first.id
  FactoryGirl.create :user, email: 'javier@trazoro.com', password: '123456', password_confirmation: '123456', population_center_id: PopulationCenter.first.id
  FactoryGirl.create :user, email: 'leandro@trazoro.com', password: '123456', password_confirmation: '123456', population_center_id: PopulationCenter.first.id
  FactoryGirl.create :user, email: 'esteban@trazoro.com', password: '123456', password_confirmation: '123456', population_center_id: PopulationCenter.first.id
  rescue
    puts 'users created ... '
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
