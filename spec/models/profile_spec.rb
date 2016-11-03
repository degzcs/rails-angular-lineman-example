# == Schema Information
#
# Table name: profiles
#
#  id                          :integer          not null, primary key
#  first_name                  :string(255)
#  last_name                   :string(255)
#  document_number             :string(255)
#  phone_number                :string(255)
#  available_credits           :float
#  address                     :string(255)
#  rut_file                    :string(255)
#  photo_file                  :string(255)
#  mining_authorization_file   :text
#  legal_representative        :boolean
#  id_document_file            :text
#  nit_number                  :string(255)
#  city_id                     :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  user_id                     :integer
#  habeas_data_agreetment_file :string(255)
#  fine_gram_value             :float
#

require 'spec_helper'

describe Profile, type: :model do
  context 'factory text' do
    let(:profile) { create :profile }
    it 'should to test the profile factory' do
      expect(profile).to be_valid
    end

    context 'Validations' do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:document_number) }
      it { should validate_presence_of(:phone_number) }
      it { should validate_presence_of(:address) }
      it { should validate_presence_of(:city) }
    end
  end
end
