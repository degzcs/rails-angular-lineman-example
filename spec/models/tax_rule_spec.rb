# == Schema Information
#
# Table name: tax_rules
#
#  id            :integer          not null, primary key
#  tax_id        :integer
#  seller_regime :string(255)
#  buyer_regime  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

RSpec.describe TaxRule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
