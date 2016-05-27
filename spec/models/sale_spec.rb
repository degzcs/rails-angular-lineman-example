# == Schema Information
#
# Table name: sales
#
#  id            :integer          not null, primary key
#  courier_id    :integer
#  client_id     :integer
#  user_id       :integer
#  gold_batch_id :integer
#  code          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  price         :float
#  trazoro       :boolean          default(FALSE), not null
#

require 'spec_helper'

describe Sale do
  context "test factory" do
    let(:sale) { build(:sale) }
    it {expect(sale.courier).not_to be_nil }
    it {expect(sale.user).not_to be_nil}
    it {expect(sale.client).not_to be_nil }
    it {expect(sale.gold_batch).not_to be_nil}
    it {expect(sale.code).not_to be_nil}
    it {expect(sale.origin_certificate_file).not_to be_nil}
    it {expect(sale.price).not_to be_nil}
  end
  context "sale creation" do
    it "should create a new sale with valid data" do
      expect(build(:sale)).to be_valid
    end

    context "for a trazoro sale (user - user sale)" do
      let!(:user1) { create(:user, :with_company) }
      let!(:client) {create(:user, :with_company)}
      let(:sale) {create(:sale, user: user1, client: client, trazoro: true)}
      it "expect to have the correct user" do
        expect(sale.trazoro).to be true
        expect(sale.user).to eq user1
      end
      it "expect to have the correct client" do
        expect(sale.trazoro).to be true
        expect(sale.client).to eq client
      end
    end
    context "for an external client purchase" do
      let!(:user1) { create(:user, :with_company) }
      let!(:external_user) {create(:external_user)}
      let(:sale) {create(:sale, user: user1, client: external_user)}
      it "expect to have the correct user" do
        expect(sale.trazoro).to be false
        expect(sale.user).to eq user1
      end
      it "expect to have the correct client" do
        expect(sale.trazoro).to be false
        expect(sale.client).to eq external_user
      end
    end
  end

  context "test barcode generations" do
    it "should generate a code when the sale is created" do
      new_sale = create(:sale)
      expect(new_sale.code).not_to be_nil
    end
  end
end
