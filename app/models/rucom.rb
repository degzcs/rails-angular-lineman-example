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

class Rucom < ActiveRecord::Base

  has_one :provider


end
