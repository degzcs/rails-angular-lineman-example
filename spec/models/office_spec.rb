# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

# require 'rails_helper'

require 'spec_helper'

describe Office  do
  context "test factory" do
    let(:office) {build(:office)}
    it {expect(office.name).not_to be_nil }
    it {expect(office.company).not_to be_nil }
  end

  context "company creation" do
    it "should create a new company with valid data " do
      expect(build(:office)).to be_valid
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:company) }
  end

end
