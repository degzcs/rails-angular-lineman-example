# == Schema Information
#
# Table name: companies
#
#  id                       :integer          not null, primary key
#  nit_number               :string(255)
#  name                     :string(255)
#  legal_representative     :string(255)
#  id_type_legal_rep        :string(255)
#  email                    :string(255)
#  phone_number             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  id_number_legal_rep      :string(255)
#  chamber_of_commerce_file :string(255)
#  external                 :boolean          default(FALSE), not null
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  country                  :string(255)
#  state                    :string(255)
#  city                     :string(255)
#

require 'spec_helper'

describe Company  do
  context "test factory" do
    let(:company) {build(:company)}
    it {expect(company.nit_number).not_to be_nil }
    it {expect(company.name).not_to be_nil }
    it {expect(company.city).not_to be_nil}
    it {expect(company.state).not_to be_nil}
    it {expect(company.country).not_to be_nil}
    it {expect(company.legal_representative).not_to be_nil}
    it {expect(company.id_type_legal_rep).not_to be_nil}
    it {expect(company.id_number_legal_rep).not_to be_nil}
    it {expect(company.email).not_to be_nil }
    it {expect(company.phone_number).not_to be_nil}
    it { expect(company.chamber_of_commerce_file).not_to be_nil }
    it { expect(company.rut_file).not_to be_nil }
    it { expect(company.mining_register_file).not_to be_nil }

  end

  context "company creation" do
    it "should create a new company with valid data " do
      expect(build(:company)).to be_valid
    end
    it { should validate_presence_of(:nit_number) }
    #it { should validate_presence_of(:city) }
    #it { should validate_presence_of(:state) }
    #it { should validate_presence_of(:country) }
    it { should validate_presence_of(:legal_representative) }
    it { should validate_presence_of(:id_number_legal_rep) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:rucom) }
    # it { should validate_presence_of(:mining_register_file)}
    it { should validate_presence_of(:rut_file)}
    it { should validate_presence_of(:chamber_of_commerce_file)}
  end

end
