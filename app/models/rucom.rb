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
	validate_presence_of: idrucom
end
