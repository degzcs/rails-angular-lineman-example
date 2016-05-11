# == Schema Information
#
# Table name: population_centers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  longitude  :decimal(, )
#  latitude   :decimal(, )
#  city_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#  code       :string(255)
#

require 'spec_helper'

describe PopulationCenter do
  subject(:population_center){build :population_center}

  context 'factory' do
    xit 'has a valid factory' do
      expect(population_center).to be_valid
    end
  end

  context 'associations' do
    xit { should belong_to :city}
  end
end
