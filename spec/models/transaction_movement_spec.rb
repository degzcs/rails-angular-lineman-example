# == Schema Information
#
# Table name: transaction_movements
#
#  id             :integer          not null, primary key
#  puc_account_id :integer
#  type           :string(255)
#  block_name     :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  afectation     :string(255)
#

require 'spec_helper'

RSpec.describe TransactionMovement, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
