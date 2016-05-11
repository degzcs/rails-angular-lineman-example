# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#


describe Country, type: :model do
  let(:country){ build :country}

  it 'has a valid factory' do
      should be_valid
  end

  context 'validations' do
    it { have_many :state }
  end
end
