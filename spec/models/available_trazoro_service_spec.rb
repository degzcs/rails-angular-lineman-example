# == Schema Information
#
# Table name: available_trazoro_services
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  credist    :float
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe AvailableTrazoroService, type: :model do
  context 'factory text' do
    let(:service) { create :available_trazoro_service }
    it 'should to test the profile factory' do
      expect(service).to be_valid
    end

    context 'Validations' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:credist) }
    end
  end

  context 'associations with roles' do
    it { should have_and_belong_to_many :user_settings }
  end
end
