# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  country_id :integer
#  code       :string(255)
#

require 'spec_helper'

describe State, type: :model do
  let(:state){ build :state}

  it 'has a valid factory' do
      should be_valid
  end

  context 'associations' do
    it { belong_to :country }
  end
end
