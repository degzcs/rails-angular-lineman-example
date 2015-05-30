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
#  rucomeable_type    :string(255)
#  rucomeable_id      :integer
#

class Rucom < ActiveRecord::Base

  belongs_to :rucomeable,  polymorphic: true

 # this method is just for clarfy the user activity related with gold.
  def activity
    self.provider_type
  end

end
