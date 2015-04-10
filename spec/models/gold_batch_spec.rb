# == Schema Information
#
# Table name: gold_batches
#
#  id             :integer          not null, primary key
#  parent_batches :text
#  grams          :float
#  grade          :integer
#  inventory_id   :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

RSpec.describe GoldBatch, type: :model do
  let(:gold_batch){ build :gold_batch}

  it 'has a valid factory' do
      should be_valid
  end

  context 'validations' do
    it {have_many :purchases}
  end
end
