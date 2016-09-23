# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  password_digest    :string(255)
#  reset_token        :string(255)
#  office_id          :integer
#  external           :boolean          default(FALSE), not null
#  registration_state :string(255)
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
    let(:user) { create(:user, :with_personal_rucom) }

    it 'should to valid the user factory' do
      expect(user).to be_valid
    end
  end

  context 'associations with roles' do
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

    it 'should create a user with 0 available credits by default' do
      user = create(:user, :with_profile, :with_personal_rucom)
      expect(user.profile.available_credits).to eq(0.0)
    end

    xit { should validate_presence_of(:email) }

    it 'should not allow to create an authorized_provider without personal_rucom if does not have office' do
      user = build(:user, :with_authorized_provider_role, personal_rucom: nil, office: nil, email: nil)
      expect(user).not_to be_valid
    end

    it 'should allow create an authorized provider user without email' do
      user = create(:user, :with_personal_rucom, :with_authorized_provider_role, email: nil)
      expect(user.valid?).to eq true
    end
  end

  context 'scopes' do
    before :each do
      @users = create_list(:user, 5, :with_personal_rucom, :with_profile) # or internal traders

      @user_with_trader_role = create_list(:user, 3, :with_company, :with_personal_rucom, :with_trader_role)
      @user_with_final_client_role = create_list(:user, 3, :with_personal_rucom, :with_final_client_role)
      @user_with_transporter_role = create_list(:user, 3, :with_personal_rucom, :with_transporter_role)

      @users_with_any_rucom = create_list(:user, 5, :with_personal_rucom, :with_profile)
      @external_traders = create_list(:user, 6, :with_personal_rucom, password: nil, password_confirmation: nil)

      @clients_with_fake_personal_rucom = create_list(:client_with_fake_personal_rucom, 3)
      @clients_with_fake_rucom = create_list(:client_with_fake_rucom, 6)

      # add credits to buy gold
      @users.last.profile.update_attribute(:available_credits, 2000)
      @users_with_any_rucom.last.profile.update_attribute(:available_credits, 2000)
    end

    it 'should return all users except with authorized_provider user role' do
      expect(User.not_authorize_providers_users.count).to eq [@user_with_trader_role, @user_with_final_client_role, @user_with_transporter_role].flatten.compact.uniq.count
    end

    xit 'should return all system users, it means, all uses that be logged in the platform (This scope has to be upgraded based on the new specifications)' do
      expect(User.system_users.count).to eq @users.count
    end

    xit 'should return all extenal users, they can have one of the next personal_rucom or company rucom' do
      expect(User.users.count).to eq [@users_with_any_rucom, @external_traders].flatten.compact.uniq.count
    end

    it 'should select all user that can provider gold (providers)' do
      expect(User.providers.count).to eq 2
    end

    xit 'should select all users with fake rucom (This scope has to be removed asap!!!)' do
      expect(User.clients_with_fake_rucom.count).to be [@clients_with_fake_personal_rucom, @clients_with_fake_rucom].flatten.compact.uniq.count
    end

    xit 'should select all users that are comercializadores' do
      # NOTE:we have to ask to the client if all users that can register in the platform have associated (by their company) to one rucom which its provider is the type 'Comercializador'
      expect(User.comercializadores.count).to be 5
    end

    xit 'should select all users called clients (This scope has to has to be changed in line with the new requirements)' do
      expect(User.clients.count).to eq  [@users, @comercializadores, @clients_with_fake_personal_rucom, @clients_with_fake_rucom].flatten.compact.uniq.count
    end
  end

  context '#instance methods' do
    context 'company methods' do
      it 'should return the company name' do
        user = create(:user, :with_company)
        expect(user.company_name).to eq Company.last.name
      end

      xit 'should returns the company nit' do
        user = create(:user, :with_company)
        expect(user.nit).not_to eq Company.last.nit_number
        expect(user.nit).to eq user.nit_number
      end
    end

    context 'rucom' do
      context 'users or external users with company' do
        it 'should respond with the rucom\'s company' do
          user = create(:user, :with_company)
          expect(user.rucom).to eq user.company.rucom
        end
      end

      context 'external user without company' do
        it 'should respond with the rucom\'s user' do
          personal_rucom = create(:rucom)
          user = create(:user, office: nil, personal_rucom: personal_rucom)
          expect(user.personal_rucom).to eq personal_rucom
        end
      end
    end

    context 'authorized provider' do
      it 'should returns the user activity from rucom info' do
        rucom = create(:rucom)
        authorized_provider = create(:user, :with_authorized_provider_role, personal_rucom: rucom, office: nil)
        expect(authorized_provider.activity).to eq rucom.activity
      end

      it 'should validate the rucom called personal rucom' do
        user = build(:user, personal_rucom: nil)
        user.valid?
        expect(user.errors.full_messages.last).to eq("Personal rucom can't be blank")
      end
    end

    context 'normal users' do
      it 'should returns the user activity trough company model' do
        user = create(:user, :with_company, personal_rucom: nil)
        expect(user.activity).to eq user.company.rucom.activity
      end

      it 'should allows create a users without personal rucom' do
        user = create(:user, :with_company, personal_rucom: nil)
        expect(user.persisted?).to eq true
      end

      xit 'should not allow to create a user without office (this case is not enough.. create more test about this)' do
        user = create(:user, :with_personal_rucom, office: nil)
        expect(user.persisted?).to eq false
      end
    end

    it 'should create a JWT' do
      expect(subject.create_token).not_to be_nil
    end

    context 'discount_available_credits' do
      let(:user) { create(:user, :with_profile, :with_personal_rucom, available_credits: 5000) }

      it 'should discount an amount of credits from the available_credits' do
        user.profile.discount_available_credits(400)
        expect(user.profile.available_credits).to eq 4600
      end

      it 'should not allow to discount credits if the amount is less than 0' do
        expect { user.profile.discount_available_credits(10_000) }.to raise_error(Profile::EmptyCredits)
      end
    end

    context 'add_available_credits' do
      let(:user) { create(:user, :with_profile, :with_personal_rucom, available_credits: 5000) }
      it 'should discount an amount of credits from the available_credits' do
        user.profile.add_available_credits(400)
        expect(user.available_credits).to eq 5400
      end
    end
  end

  context '#Class methods' do
    before :each do
      @user = create :user, :with_personal_rucom
      @token = @user.create_token
    end

    it 'should returns decode the JWT' do
      expect(User.valid?(@token).first).to include('user_id' => @user.id.to_s)
      expect(User.valid?(@token).last).to include('typ' => 'JWT', 'alg' => 'HS256')
    end

    it 'should retrun false because the token is invalid' do
      expect(User.valid?("#{@token}-invalid")).to be false
    end
  end

  context 'abilities' do
    context 'trader abilities' do
      before :each do
        trader_user = create :user, :with_company, :with_profile, :with_personal_rucom, :with_trader_role
        @abilities = Ability.new(trader_user)
      end

      it 'should valid if the user has the trader abilities' do
        expect(@abilities).to be_able_to(:read, Order.new)
        expect(@abilities).to be_able_to(:create, Order.new)
      end
    end
  end

  context 'user roles with_authorized_provider_role' do
    before :each do
      @user = create :user, :with_personal_rucom, :with_authorized_provider_role
      # :with_final_client_role, :with_trader_role, :with_transporter_role
    end

    it 'should check that user is a authorized provider' do
      # @user.roles.map(&:name)) include("authorized_provider")
      expect(@user.authorized_provider?).to be true
    end
  end

  context 'user roles :with_final_client_role' do
    before :each do
      @user = create :user, :with_personal_rucom, :with_final_client_role
      # :with_trader_role, :with_transporter_role
    end

    it 'should check that user is a final client' do
      # @user.roles.map(&:name)) include("authorized_provider")
      expect(@user.final_client?).to be true
    end
  end

  context 'user roles :with_trader_role' do
    before :each do
      @user = create :user, :with_personal_rucom, :with_transporter_role
    end

    it 'should check that user is a transporter' do
      expect(@user.transporter?).to be true
    end
  end
end
