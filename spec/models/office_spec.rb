# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

# require 'rails_helper'

RSpec.describe Office, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
