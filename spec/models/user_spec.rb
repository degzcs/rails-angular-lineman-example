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
#  chamber_commerce_file    :string(255)
#

require 'spec_helper'

describe  User do
  context 'test factory' do
    let(:user){ build(:user) }

    it { expect(user.email).not_to be_nil }
    it { expect(user.password).not_to be_nil }
    it { expect(user.password_digest).not_to be_nil }
    it { expect(user.first_name).not_to be_nil }
    it { expect(user.last_name).not_to be_nil }
    it { expect(user.document_number).not_to be_nil }
    it { expect(user.document_expedition_date).not_to be_nil }
    it { expect(user.phone_number).not_to be_nil }
    it { expect(user.available_credits).not_to be_nil }
    it { expect(user.address).not_to be_nil }
  end

  context 'create user' do

    it 'should create a user' do
      user = build(:user, password: 'super_password', password_confirmation: 'super_password')
      expect(user.save).to be true
    end 

    it 'should not create a user because their password is incorrect' do
      user = build(:user, password: 'nomatch', password_confirmation: 'paila')
      expect(user.save).to be false
    end 

    it "should create a user with 0 available credits by default" do
      user = create(:user)
      expect(user.available_credits).to eq(0.0)
    end
  
    it 'should trigger save_client on save' do
      user = build(:user, password: 'super_password', password_confirmation: 'super_password')
      user.should_receive(:save_client)
      user.save
    end

  end

  context '#instance methods' do 
    it 'should create a JWT' do 
      expect(subject.create_token).not_to be_nil
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
