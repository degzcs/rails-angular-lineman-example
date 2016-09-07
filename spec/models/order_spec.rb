# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  buyer_id       :integer
#  seller_id      :integer
#  courier_id     :integer
#  type           :string(255)
#  code           :string(255)
#  price          :string(255)
#  seller_picture :string(255)
#  trazoro        :boolean          default(FALSE), not null
#  boolean        :boolean          default(FALSE), not null
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
