# == Schema Information
#
# Table name: population_centers
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  longitude              :decimal(, )
#  latitude               :decimal(, )
#  type                   :string(255)
#  city_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  population_center_code :string(255)      not null
#  city_code              :string(255)      not null
#

require 'rails_helper'

RSpec.describe PopulationCenter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
