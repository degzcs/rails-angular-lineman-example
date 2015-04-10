# == Schema Information
#
# Table name: rucoms
#
#  idrucom            :string(90)       not null
#  rucom_record       :text
#  name               :text
#  status             :text
#  mineral            :text
#  location           :text
#  subcontract_number :text
#  mining_permit      :text
#  updated_at         :datetime
#  provider_type      :string(255)
#  num_rucom          :string(255)
#  id                 :integer          not null, primary key
#

require 'spec_helper'

describe Rucom  do
  
  context "test factory" do
    let(:rucom) {build(:rucom)}
    it {expect(rucom.idrucom).not_to be_nil }
    it {expect(rucom.rucom_record).not_to be_nil }
    it {expect(rucom.name).not_to be_nil}
    it {expect(rucom.status).not_to be_nil}
    it {expect(rucom.mineral).not_to be_nil}
    it {expect(rucom.location).not_to be_nil }
    it {expect(rucom.subcontract_number).not_to be_nil}
    it {expect(rucom.mining_permit).not_to be_nil}
    it {expect(rucom.updated_at).not_to be_nil}
    it {expect(rucom.provider_type).not_to be_nil }
    it {expect(rucom.num_rucom).not_to be_nil}
  end

end
