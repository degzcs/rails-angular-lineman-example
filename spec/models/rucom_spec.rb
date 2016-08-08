# == Schema Information
#
# Table name: rucoms
#
#  id              :integer          not null, primary key
#  rucom_number    :string(255)
#  name            :string(255)
#  original_name   :string(255)
#  minerals        :string(255)
#  location        :string(255)
#  status          :string(255)
#  provider_type   :string(255)
#  rucomeable_type :string(255)
#  rucomeable_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Rucom  do
  context 'test factory' do
    let(:rucom) { build(:rucom) }
    it { expect(rucom.rucom_number).not_to be_nil }
    it { expect(rucom.name).not_to be_nil }
    it { expect(rucom.original_name).not_to be_nil }
    it { expect(rucom.status).not_to be_nil }
    it { expect(rucom.minerals).not_to be_nil }
    it { expect(rucom.location).not_to be_nil }
    it { expect(rucom.provider_type).not_to be_nil }
  end
end
