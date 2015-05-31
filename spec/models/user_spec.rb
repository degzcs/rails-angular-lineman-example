# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  first_name               :string(255)
#  last_name                :string(255)
#  email                    :string(255)
#  document_number          :string(255)
#  document_expedition_date :date
#  phone_number             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  password_digest          :string(255)
#  available_credits        :float
#  reset_token              :string(255)
#  address                  :string(255)
#  document_number_file     :string(255)
#  rut_file                 :string(255)
#  mining_register_file     :string(255)
#  photo_file               :string(255)
#  population_center_id     :integer
#  office_id                :integer
#  external                 :boolean          default(FALSE), not null
#

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
#  password_digest          :string(255)
#  available_credits        :float
#  reset_token              :string(255)
#


require 'spec_helper'

describe  User do
  context 'test factory' do
    let(:user){ build(:user) }
    it { expect(user.first_name).not_to be_nil }
    it { expect(user.last_name).not_to be_nil }
    it { expect(user.email).not_to be_nil }
    it { expect(user.document_number).not_to be_nil }
    it { expect(user.document_expedition_date).not_to be_nil }
    it { expect(user.phone_number).not_to be_nil }
    it { expect(user.address).not_to be_nil }
    it { expect(user.document_number_file).not_to be_nil }
    it { expect(user.rut_file).not_to be_nil }
    it { expect(user.mining_register_file).not_to be_nil }
    it { expect(user.photo_file).not_to be_nil }
    # it { expect(user.chamber_commerce_file).not_to be_nil }
    # it { expect(user.company).not_to be_nil } TODO: use office model to access to company model
    it { expect(user.population_center).not_to be_nil }
    it { expect(user.available_credits).not_to be_nil }
  end

  context 'create user' do

    it 'should create a user' do
      user = build(:user, password: 'super_password', password_confirmation: 'super_password')
      expect(user.save).to be true
    end

    it 'should not create a user because his password is incorrect' do
      user = build(:user, password: 'nomatch', password_confirmation: 'paila')
      expect(user.save).to be false
    end

    it "should create a user with 0 available credits by default" do
      user = create(:user)
      expect(user.available_credits).to eq(0.0)
    end

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:document_number) }
    # it { should validate_presence_of(:document_expedition_date) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:document_number_file) }
    it { should validate_presence_of(:rut_file) }
    it { should validate_presence_of(:mining_register_file) }
    it { should validate_presence_of(:photo_file) }
    # it { should validate_presence_of(:chamber_commerce_file) }
    it { should validate_presence_of(:office) }
    it { should validate_presence_of(:population_center) }

  end

  context "scopes" do
    before :each do
      create_list(:user, 5 )
      create_list(:external_user, 5)
    end

    it 'should return all extenal users' do
      expect(User.external_users.count).to eq 5
    end

  end

  context '#instance methods' do

    context "company methods" do
      it 'should return the company name' do
        user = create(:user)
        expect(user.company_name).to eq Company.last.name
      end

      it 'should returns the company nit' do
        user = create(:user)
        expect(user.nit).to eq Company.last.nit_number
      end
    end

    context "external users" do
      it "should returns the user activity from rucom info" do
        rucom = create(:rucom)
        user = create(:user, external: true,  personal_rucom: rucom)
        expect(user.activity).to eq rucom.activity
      end

      it "should validate the rucom called personal rucom" do
        user = build(:user, external: true,  personal_rucom: nil)
        expect(user).not_to be_valid
      end

    end

    context "normal users" do

      it 'should returns the user activity trough company model' do
        user = create(:user, external: false,  personal_rucom: nil)
        rucom = user.company.rucom
        expect(user.activity).to eq rucom.activity
      end

       it "should allows create a users without personal rucom" do
        user = build(:user, external: false,  personal_rucom: nil)
        expect(user).to be_valid
      end
    end

    it 'should create a JWT' do
      expect(subject.create_token).not_to be_nil
    end
    context "discount_available_credits" do
      let(:user) {create(:user, available_credits: 5000)}
      it "should discount an amount of credits from the available_credits" do
        user.discount_available_credits(400)
        expect(user.available_credits).to eq 4600
      end
      it "should not allow to discount credits if the amount is less than 0" do
        expect{user.discount_available_credits(10000)}.to raise_error(User::EmptyCredits)
      end
    end
    context "add_available_credits" do
      let(:user) {create(:user, available_credits: 5000)}
      it "should discount an amount of credits from the available_credits" do
        user.add_available_credits(400)
        expect(user.available_credits).to eq 5400
      end
    end
  end

  context '#Class methods' do
    before :each do
     @user =create :user
     @token = @user.create_token
    end

    it 'should returns decode the JWT' do
      expect(User.valid?(@token).first).to include("user_id" => @user.id.to_s)
      expect(User.valid?(@token).last).to include({"typ"=>"JWT", "alg"=>"HS256"})
    end

    it 'should retrun false because the token is invalid' do
      expect(User.valid?("#{@token}-invalid")).to be false
    end
  end

end
