require 'spec_helper'

describe Provider do
  context "test factory" do
    let(:provider) {build(:provider)}
    it {expect(provider.document_number).not_to be_nil }
    it {expect(provider.type).not_to be_nil }
    it {expect(provider.first_name).not_to be_nil}
    it {expect(provider.last_name).not_to be_nil}
    it {expect(provider.phone_number).not_to be_nil}
    it {expect(provider.address).not_to be_nil }
    it {expect(provider.company_info).not_to be_nil}
  end

  context "test creation" do

    it "should create a new provider with valid data" do
      expect(build(:provider)).to be_valid
    end

    it "should not allow to create a provider without a rucom" do
      expect(build(:provider, rucom: nil)).not_to be_valid
    end

    it "should not allow to create a provider without document_number" do
      provider = build(:provider, document_number: nil)
      expect(provider).not_to be_valid
    end
    
    it "should not allow to create a provider without type" do
      provider = build(:provider, type: nil)
      expect(provider).not_to be_valid
    end

    it "should not allow to create a provider without first_name" do
      provider = build(:provider, first_name: nil)
      expect(provider).not_to be_valid
    end
    it "should not allow to create a provider without last_name" do
      provider = build(:provider, last_name: nil)
      expect(provider).not_to be_valid
    end
    it "should not allow to create a provider without phone_number" do
      provider = build(:provider, phone_number: nil)
      expect(provider).not_to be_valid
    end
    it "should not allow to create a provider without address" do
      provider = build(:provider, address: nil)
      expect(provider).not_to be_valid
    end
  end

  context "#Instance methods" do
    context "is_company?" do
      it "should return true if the provider has company_info" do
        company_info = build(:company_info)
        provider = build(:provider,company_info: company_info)
        expect(provider.is_company?).to be true
      end
      it "should return false if the provider has no company_info" do
        provider = build(:provider, company_info: nil)
        expect(provider.is_company?).to be false
      end
    end
  end
  
end
