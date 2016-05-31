# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#  city_id    :integer
#  address    :string(255)
#

FactoryGirl.define do
  factory :office do
    sequence(:name) { |n| "office-#{n}" }
    company
    address { Faker::Address.street_address }
  end

  trait :with_fake_rucom do
    after :build do |office|
      rucom = create(:rucom, :for_clients)
      office.company = create(:company, rucom: rucom)
    end
  end

end
