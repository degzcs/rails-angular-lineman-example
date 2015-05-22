# == Schema Information
#
# Table name: clients
#
#  id                   :integer          not null, primary key
#  first_name           :string(255)
#  last_name            :string(255)
#  phone_number         :string(255)
#  company_name         :string(255)
#  address              :string(255)
#  nit_company_number   :string(255)
#  id_document_type     :string(255)
#  id_document_number   :string(255)
#  client_type          :string(255)
#  rucom_id             :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  population_center_id :integer
#  email                :string(255)
#

require 'spec_helper'

describe ExternalClient do
  context "test factory" do
    let(:client) {build(:external_client)}
    it {expect(client.id_document_number).not_to be_nil }
    it {expect(client.id_document_type).not_to be_nil }
    it {expect(client.first_name).not_to be_nil}
    it {expect(client.last_name).not_to be_nil}
    it {expect(client.phone_number).not_to be_nil}
    it {expect(client.address).not_to be_nil }
    it {expect(client.population_center_id).not_to be_nil}
    it {expect(client.email).not_to be_nil}
    it {expect(client.client_type).not_to be_nil}
  end

  context "test creation" do

    it "should create a new client with valid data" do
      expect(build(:client)).to be_valid
    end

    it "should not allow to create a client without id_document_number" do
      client = build(:client, id_document_number: nil)
      expect(client).not_to be_valid
    end

    it "should not allow to create a client without id_document_type" do
      client = build(:client, id_document_type: nil)
      expect(client).not_to be_valid
    end

    it "should not allow to create a client without client_type" do
      client = build(:client, client_type: nil)
      expect(client).not_to be_valid
    end
    
    it "should not allow to create a client without first_name" do
      client = build(:client, first_name: nil)
      expect(client).not_to be_valid
    end
    it "should not allow to create a client without last_name" do
      client = build(:client, last_name: nil)
      expect(client).not_to be_valid
    end
    it "should not allow to create a client without phone_number" do
      client = build(:client, phone_number: nil)
      expect(client).not_to be_valid
    end
    it "should not allow to create a client without email" do
      client = build(:client, email: nil)
      expect(client).not_to be_valid
    end
  end
end