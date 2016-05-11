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

describe City, type: :model do
  let(:city){ build :city}

  it 'has a valid factory' do
      should be_valid
  end

  context 'associations' do
    it { belong_to :state }
  end
end
