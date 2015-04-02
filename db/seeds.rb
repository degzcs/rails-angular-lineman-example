# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

FactoryGirl.create :user, email: 'diego@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'jesus@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'camilo@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'javier@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'leandro@trazoro.com', password: '123456', password_confirmation: '123456'
FactoryGirl.create :user, email: 'esteban@trazoro.com', password: '123456', password_confirmation: '123456'

rucoms = FactoryGirl.create_list(:rucom, 20)
rucoms.each do|rucom|
	FactoryGirl.create(:provider,rucom_id: rucom.id)
end