# == Schema Information
#
# Table name: puc_accounts
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

RSpec.describe PucAccount, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
