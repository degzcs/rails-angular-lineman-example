# == Schema Information
#
# Table name: taxes
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  reference      :string(255)
#  porcent        :float
#  puc_account_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

RSpec.describe Tax, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
