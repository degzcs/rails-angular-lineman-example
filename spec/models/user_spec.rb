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
end
