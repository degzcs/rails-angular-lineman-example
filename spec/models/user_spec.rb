require 'spec_helper'

describe  User do
  context 'test factory' do
    let(:user){ build(:user) }

    it { expect(user.email).not_to be_nil }
    it { expect(user.password).not_to be_nil }
    it { expect(user.first_name).not_to be_nil }
    it { expect(user.last_name).not_to be_nil }
    it { expect(user.document_number).not_to be_nil }
    it { expect(user.document_expedition_date).not_to be_nil }
    it { expect(user.phone_number).not_to be_nil }
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
