# == Schema Information
#
# Table name: external_users
#
#  id                       :integer          not null, primary key
#  first_name               :string(255)
#  last_name                :string(255)
#  email                    :string(255)
#  document_number          :string(255)
#  document_expedition_date :date
#  phone_number             :string(255)
#  address                  :string(255)

#  created_at               :datetime
#  updated_at               :datetime

#  document_number_file     :string(255)
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  photo_file               :string(255)
#  chamber_commerce_file    :string(255)
#
#  rucom_id                 :integer
#  company_id               :integer
#  population_center_id     :integer
#


require 'spec_helper'

describe ExternalUser do
  context "test factory" do
    let(:external_user) { build(:external_user) }
    it { expect(external_user.first_name).not_to be_nil }
    it { expect(external_user.last_name).not_to be_nil }
    it { expect(external_user.email).not_to be_nil }
    it { expect(external_user.document_number).not_to be_nil }
    it { expect(external_user.document_expedition_date).not_to be_nil }
    it { expect(external_user.phone_number).not_to be_nil }
    it { expect(external_user.address).not_to be_nil }
    it { expect(external_user.document_number_file).not_to be_nil }
    it { expect(external_user.rut_file).not_to be_nil }
    it { expect(external_user.mining_register_file).not_to be_nil }
    it { expect(external_user.photo_file).not_to be_nil }
    it { expect(external_user.chamber_commerce_file).not_to be_nil }
    it { expect(external_user.rucom).not_to be_nil }
    it { expect(external_user.company).not_to be_nil }
    it { expect(external_user.population_center).not_to be_nil }
  end

  context "external user creation" do

    it "should create a new external_user with valid data" do
      expect(build(:external_user)).to be_valid
    end

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:document_number) }
    it { should validate_presence_of(:document_expedition_date) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:document_number_file) }
    it { should validate_presence_of(:rut_file) }
    it { should validate_presence_of(:mining_register_file) }
    it { should validate_presence_of(:photo_file) }
    it { should validate_presence_of(:chamber_commerce_file) }
    it { should validate_presence_of(:rucom_id) }
    it { should validate_presence_of(:population_center) }
  end

  context "#Instance methods" do
    context "is_company?" do
      it "should return true if the external_user has company_info" do
        company = build(:company)
        external_user = build(:external_user,company: company)
        expect(external_user.is_company?).to be true
      end
      it "should return false if the external_user has no company" do
        external_user = build(:external_user, company: nil)
        expect(external_user.is_company?).to be false
      end
    end
    context "rucom" do
      it "should return the rucom of the external_user" do
        rucom = create(:rucom)
        external_user = build(:external_user, rucom_id: rucom.id)
        expect(external_user.rucom).to eq(rucom)
      end
    end
  end
  
end
