# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  state_code :string(255)      not null
#

require 'rails_helper'

RSpec.describe State, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
