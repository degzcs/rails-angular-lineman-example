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

  def self.create_trazoro(params)
    rucom_attr = {
      :idrucom=>"N/A",
       :rucom_record=>"N/A",
       :name=>"N/A",
       :status=>"N/A",
       :mineral=>"ORO",
       :location=>"N/A",
       :subcontract_number=> "N/A",
       :mining_permit=> "N/A",
       :num_rucom=>"N/A",
       :rucomeable_type=>nil,
       :rucomeable_id=>nil,
       :provider_type=>params[:provider_type],
       :trazoro => true,
      }
      self.create(rucom_attr)
  end

end
