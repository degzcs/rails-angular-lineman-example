# == Schema Information
#
# Table name: company_infos
#
#  id                   :integer          not null, primary key
#  nit_number           :string(255)
#  name                 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country              :string(255)
#  legal_representative :string(255)
#  id_type_legal_rep    :string(255)
#  email                :string(255)
#  phone_number         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  provider_id          :integer
#

require 'spec_helper'

describe CompanyInfo  do
  context "test factory" do
    let(:company_info) {build(:company_info)}
    it {expect(company_info.nit_number).not_to be_nil }
    it {expect(company_info.name).not_to be_nil }
    it {expect(company_info.city).not_to be_nil}
    it {expect(company_info.state).not_to be_nil}
    it {expect(company_info.country).not_to be_nil}
    it {expect(company_info.legal_representative).not_to be_nil}
    it {expect(company_info.id_type_legal_rep).not_to be_nil}
    it {expect(company_info.email).not_to be_nil }
    it {expect(company_info.phone_number).not_to be_nil}
  end

  context "test creation" do
    let!(:provider) {create(:provider)}
    it "should create a new company_info for a provider" do
      expect(build(:company_info, provider_id: provider.id )).to be_valid
    end
    
    it "should not allow to create a company_info without nit_number" do
      company_info = build(:company_info, provider_id: provider.id, nit_number: nil)
      expect(company_info).not_to be_valid
    end
    
    it "should not allow to create a company_info without name" do
      company_info = build(:company_info, provider_id: provider.id, name: nil)
      expect(company_info).not_to be_valid
    end

    it "should not allow to create a company_info without city" do
      company_info = build(:company_info, provider_id: provider.id, city: nil)
      expect(company_info).not_to be_valid
    end
    it "should not allow to create a company_info without state" do
      company_info = build(:company_info, provider_id: provider.id, state: nil)
      expect(company_info).not_to be_valid
    end
    it "should not allow to create a company_info without country" do
      company_info = build(:company_info, provider_id: provider.id, country: nil)
      expect(company_info).not_to be_valid
    end
    it "should not allow to create a company_info without legal_representative" do
     company_info = build(:company_info, provider_id: provider.id, legal_representative: nil)
      expect(company_info).not_to be_valid
    end
    it "should not allow to create a company_info without id_type_legal_rep" do
     company_info = build(:company_info, provider_id: provider.id, id_type_legal_rep: nil)
      expect(company_info).not_to be_valid
    end
    it "should not allow to create a company_info without email" do
     company_info = build(:company_info, provider: provider, email: nil)
      expect(company_info).not_to be_valid
    end
    it "should not allow to create a company_info without phone_number" do
     company_info = build(:company_info, provider_id: provider.id, phone_number: nil)
      expect(company_info).not_to be_valid
    end
  end

end
