require 'spec_helper'

describe Role  do
  	context "assosiations" do
  		it {should have_and_belong_to_many :users}	
  	end

  	
end