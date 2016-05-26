require 'spec_helper'

describe UserResetPassword do

  let(:user){ create(:user, :with_personal_rucom) }

  subject(:user_reset_password){ UserResetPassword.new user}

  context 'new password' do

    it 'should to send a email to reset the user password' do
       expect(user_reset_password.process!).to be_a_kind_of Mail::Message
    end

  end
end