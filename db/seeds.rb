# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create(email:'admin@example.com',password:'password')

FactoryGirl.create :user, email: 'diego@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'jesus@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'camilo@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'javier@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'leandro@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'esteban@trazoro.com', password: '123456', password_confirmation: '123456'

rucoms = FactoryGirl.create_list(:rucom, 20)
state = FactoryGirl.create(:state)
city = FactoryGirl.create(:city, state_id: state.id, state_code: state.state_code)
population_center = FactoryGirl.create(:population_center, city_id: city.id, city_code: city.city_code)
rucoms.each do|rucom|
	FactoryGirl.create(:provider,rucom_id: rucom.id, population_center_id: population_center.id)
end

states = FactoryGirl.create_list(:state, 10)
states.each do|state|
	cities = FactoryGirl.create_list(:city, 5, state_id: state.id, state_code: state.state_code)
	cities.each do|city|
		FactoryGirl.create_list(:population_center, 5, city_id: city.id, city_code: city.city_code)
	end
end