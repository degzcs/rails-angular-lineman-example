require 'spec_helper'

RSpec.describe GoldBatch, type: :model do
  let(:gold_batch){ build :gold_batch}

  it 'has a valid factory' do
      should be_valid
  end
end
