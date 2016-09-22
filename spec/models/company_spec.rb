# == Schema Information
#
# Table name: companies
#
#  id                       :integer          not null, primary key
#  nit_number               :string(255)
#  name                     :string(255)
#  email                    :string(255)
#  phone_number             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  chamber_of_commerce_file :string(255)
#  external                 :boolean          default(FALSE), not null
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  legal_representative_id  :integer
#  address                  :string(255)
#  city_id                  :integer
#

require 'spec_helper'

describe Company do
  context 'Model Company' do
    let(:company) { create(:company) }
    subject { company.complete! ; company }
    context 'test factory (on completed)' do
      it { expect(company.nit_number).not_to be_nil }
      it { expect(company.name).not_to be_nil }
      it { expect(company.city).not_to be_nil }
      it { expect(company.legal_representative).not_to be_nil }
      it { expect(company.email).not_to be_nil }
      it { expect(company.phone_number).not_to be_nil }
      it { expect(company.chamber_of_commerce_file).not_to be_nil }
      it { expect(company.rut_file).not_to be_nil }
      it { expect(company.mining_register_file).not_to be_nil }
    end

    context 'company creation' do
      it { expect(subject).to validate_presence_of(:nit_number) }
      it { expect(subject).to validate_presence_of(:legal_representative) }
      it { expect(subject).to validate_presence_of(:email) }
      it { expect(subject).to validate_presence_of(:phone_number) }
      it { expect(subject).to validate_presence_of(:rucom) }
      it { expect(subject.rut_file.present?).to be true }
      it { expect(subject.chamber_of_commerce_file.present?).to be true }
    end
  end

  context 'State Machine' do
    it 'State inserted_from_rucom' do
      city = City.first
      company = Company.new(nit_number: '567890000', address: 'calle 123', city: city)
      company.save!
      expect(company.inserted_from_rucom?).to eq true
    end

    it 'State completed' do
      name = 'compañia de prueba'
      company = create(:company, name: nil)
      company.update_attributes(name: name)
      expect(company.complete!).to eq true
      expect(company.completed?).to eq true
    end

    it 'State draft' do
      company = create(:company, name: nil, phone_number: nil, email: nil)
      expect(company.pause).to eq true
      expect(company.draft?).to eq true
    end
  end
end
