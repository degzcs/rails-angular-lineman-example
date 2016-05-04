# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  code       :string(255)
#

require 'spec_helper'

RSpec.describe City, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
end
