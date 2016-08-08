# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Role  do
  	context "assosiations" do
  		it {should have_and_belong_to_many :users}	
  	end

  	
end
