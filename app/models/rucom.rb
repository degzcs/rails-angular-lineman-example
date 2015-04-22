# == Schema Information
#
# Table name: rucoms
#
#  id                 :integer          not null, primary key
#  idrucom            :string(90)       not null
#  rucom_record       :text
#  name               :text
#  status             :text
#  mineral            :text
#  location           :text
#  subcontract_number :text
#  mining_permit      :text
#  updated_at         :datetime         default(2015-04-10 01:25:41 UTC)
#  provider_type      :string(255)
#  num_rucom          :string(255)
#

class Rucom < ActiveRecord::Base


end
