# == Schema Information
#
# Table name: couriers
#
#  id                 :integer          not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  phone_number       :string(255)
#  company_name       :string(255)
#  address            :string(255)
#  nit_company_number :string(255)
#  id_document_type   :string(255)
#  id_document_number :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Courier do
  context "test factory" do
    let(:courier) {build(:courier)}
    it {expect(courier.first_name).not_to be_nil }
    it {expect(courier.last_name).not_to be_nil}
    it {expect(courier.phone_number).not_to be_nil}
    it {expect(courier.address).not_to be_nil }
    it {expect(courier.id_document_type).not_to be_nil }
    it {expect(courier.id_document_number).not_to be_nil }
  end

  context "test creation" do

    it "should create a new courier with valid data" do
      expect(build(:courier)).to be_valid
    end

    it "should not allow to create a courier without first_name" do
      courier = build(:courier, first_name: nil)
      expect(courier).not_to be_valid
    end
    
    it "should not allow to create a courier without last_name" do
      courier = build(:courier, last_name: nil)
      expect(courier).not_to be_valid
    end

    it "should not allow to create a courier without id_document_type" do
      courier = build(:courier, id_document_type: nil)
      expect(courier).not_to be_valid
    end

    it "should not allow to create a courier without id_document_number" do
      courier = build(:courier, id_document_number: nil)
      expect(courier).not_to be_valid
    end
    
    
    it "should not allow to create a courier without phone_number" do
      courier = build(:courier, phone_number: nil)
      expect(courier).not_to be_valid
    end
    
    it "should not allow to create a courier without address" do
      courier = build(:courier, address: nil)
      expect(courier).not_to be_valid
    end
  end
end
