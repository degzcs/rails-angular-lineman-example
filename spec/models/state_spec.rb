# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  country_id :integer
#  code       :string(255)
#

require 'spec_helper'

RSpec.describe State, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
end
