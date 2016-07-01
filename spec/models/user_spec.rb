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
#  rut_file                 :string(255)
#  photo_file               :string(255)
#  population_center_id     :integer
#  office_id                :integer
#  external                 :boolean          default(FALSE), not null
#  mining_register_file     :string(255)
#  legal_representative     :boolean          default(FALSE)
#  id_document_file         :text
#  nit_number               :string(255)
#  city_id                  :integer
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

describe  User, type: :model do
  context 'test factory' do
    let(:user){ create(:user, :with_personal_rucom ) }

    it 'should to valid the user factory' do
      expect(user).to be_valid
    end

    it { expect(user.first_name).not_to be_nil }
    it { expect(user.last_name).not_to be_nil }
    it { expect(user.email).not_to be_nil }
    it { expect(user.document_number).not_to be_nil }
    it { expect(user.document_expedition_date).not_to be_nil }
    it { expect(user.phone_number).not_to be_nil }
    it { expect(user.address).not_to be_nil }
    it { expect(user.document_number_file).not_to be_nil }
    it { expect(user.rut_file).not_to be_nil }
    it { expect(user.photo_file).not_to be_nil }
    # it { expect(user.chamber_commerce_file).not_to be_nil }
    it { expect(user.available_credits).not_to be_nil }
  end

  context 'associations' do
    it { should have_and_belong_to_many :roles }
  end

  context 'create user' do

    it 'should create a user' do
      user = create(:user, :with_personal_rucom, password: 'super_password', password_confirmation: 'super_password')
      expect(user.persisted?).to be true
    end

    it 'should not create a user because his password is incorrect' do
      user = build(:user, :with_personal_rucom, password: 'nomatch', password_confirmation: 'paila')
      expect(user.save).to be false
    end

    it "should create a user with 0 available credits by default" do
      user = create(:user, :with_personal_rucom)
      expect(user.available_credits).to eq(0.0)
    end

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:document_number) }
    # it { should validate_presence_of(:document_expedition_date) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:id_document_file) }
    it { should validate_presence_of(:photo_file) }
    # it { should validate_presence_of(:office) }
    it { should validate_presence_of(:city) }

    it "should not allow to create an external user without personal_rucom if does not have office" do
      external_user = build(:external_user, personal_rucom: nil, office: nil, email: nil)
      expect(external_user).not_to be_valid
    end

    it "should allow create an external user without email" do
      external_user = build(:external_user, email: nil)
      expect(external_user).to be_valid
    end

  end

  context "scopes" do
    before :each do
      @users = create_list(:user, 5, :with_personal_rucom) # or internal traders

      @external_users_with_any_rucom = create_list(:external_user, 5)
      @external_traders =  create_list(:user, 6, :with_personal_rucom, password: nil, password_confirmation: nil, external: true)

      @clients_with_fake_personal_rucom = create_list(:client_with_fake_personal_rucom, 3)
      @clients_with_fake_rucom = create_list(:client_with_fake_rucom, 6)

      # add credits to buy gold
     @users.last.update_attribute(:available_credits, 2000)
     @external_users_with_any_rucom.last.update_attribute(:available_credits, 2000)
    end

    xit 'should return all system users, it means, all uses that be logged in the platform (This scope has to be upgraded based on the new specifications)' do
      expect(User.system_users.count).to eq @users.count
    end

    xit 'should return all extenal users, they can have one of the next personal_rucom or company rucom' do
      expect(User.external_users.count).to eq [@external_users_with_any_rucom, @external_traders].flatten.compact.uniq.count
    end

    it 'should select all user that can provider gold (providers)' do
      expect(User.providers.count).to eq  2
    end

    xit 'should select all users with fake rucom (This scope has to be removed asap!!!)' do
      expect(User.clients_with_fake_rucom.count).to be [@clients_with_fake_personal_rucom, @clients_with_fake_rucom].flatten.compact.uniq.count
    end

    xit 'should select all users that are comercializadores' do
      #NOTE:we have to ask to the client if all users that can register in the platform have associated (by their company) to one rucom which its provider is the type 'Comercializador'
      expect(User.comercializadores.count).to be 5
    end

    xit 'should select all users called clients (This scope has to has to be changed in line with the new requirements)' do
      expect(User.clients.count).to eq  [@users, @comercializadores, @clients_with_fake_personal_rucom, @clients_with_fake_rucom].flatten.compact.uniq.count
    end
  end

  context '#instance methods' do

    context "company methods" do
      it 'should return the company name' do
        user = create(:user, :with_company)
        expect(user.company_name).to eq Company.last.name
      end

      it 'should returns the company nit' do
        user = create(:user, :with_company)
        expect(user.nit).not_to eq Company.last.nit_number
        expect(user.nit).to eq user.nit_number
      end
    end

    context "rucom" do
      context "users or external users with company" do
        it "should respond with the rucom's company" do
          user = create(:user, :with_company)
          external_user = create(:external_user, :with_company)
          expect(user.rucom).to eq user.company.rucom
          expect(external_user.rucom).to eq external_user.company.rucom
        end
      end

      context "external user without company" do
        it "should respond with the rucom's user" do
          personal_rucom = create(:rucom)
          external_user = create(:external_user, office: nil, personal_rucom: personal_rucom)
          expect(external_user.personal_rucom).to eq personal_rucom
        end
      end
    end

    context "external users" do
      it "should returns the user activity from rucom info" do
        rucom = create(:rucom)
        external_user = create(:external_user, personal_rucom: rucom, office: nil)
        expect(external_user.activity).to eq rucom.activity
      end

      xit "should validate the rucom called personal rucom" do
        user = build(:user, external: true,  personal_rucom: nil)
        expect(user).not_to be_valid
      end

    end

    context "normal users" do

      it 'should returns the user activity trough company model' do
        user = create(:user, :with_company, external: false,  personal_rucom: nil)
        expect(user.activity).to eq user.company.rucom.activity
      end

      it "should allows create a users without personal rucom" do
        user = create(:user, :with_company, external: false,  personal_rucom: nil)
        expect(user.persisted?).to eq true
      end

      xit "should not allow to create a user without office (this case is not enough.. create more test about this)" do
        user = create(:user, :with_personal_rucom, external: false,  office: nil)
        expect(user.persisted?).to eq false
      end
    end

    it 'should create a JWT' do
      expect(subject.create_token).not_to be_nil
    end

    context "discount_available_credits" do
      let(:user) {create(:user, :with_personal_rucom, available_credits: 5000)}

      it "should discount an amount of credits from the available_credits" do
        user.discount_available_credits(400)
        expect(user.available_credits).to eq 4600
      end

      it "should not allow to discount credits if the amount is less than 0" do
        expect{ user.discount_available_credits(10000) }.to raise_error(User::EmptyCredits)
      end
    end

    context "add_available_credits" do
      let(:user) {create(:user, :with_personal_rucom, available_credits: 5000)}
      it "should discount an amount of credits from the available_credits" do
        user.add_available_credits(400)
        expect(user.available_credits).to eq 5400
      end
    end
  end

  context '#Class methods' do
    before :each do
     @user =create :user, :with_personal_rucom
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
