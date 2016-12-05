# == Schema Information
#
# Table name: gold_batches
#
#  id              :integer          not null, primary key
#  fine_grams      :float
#  grade           :integer
#  created_at      :datetime
#  updated_at      :datetime
#  extra_info      :text
#  goldomable_type :string(255)
#  goldomable_id   :integer
#  sold            :boolean          default(FALSE)
#  mineral_type    :string(255)
#

require 'spec_helper'

RSpec.describe GoldBatch, type: :model do
  let(:gold_batch){ build :gold_batch}

  it 'has a valid factory' do
    should be_valid
  end

  xcontext 'validations' do
  end
end
