# == Schema Information
#
# Table name: rucoms
#
#  idrucom            :string(90)       not null, primary key
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
#

# idrucom Varchar (90)
# record Text 
# name Text
# status Text
# mineral Text
# location Text
# subcontract_number Text
# mining_permit Text
# updated_at Datetime

class Rucom < ActiveRecord::Base
	validates_presence_of :idrucom
end
