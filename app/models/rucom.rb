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
#  updated_at         :datetime         default(2016-05-19 03:51:59 UTC)
#  provider_type      :string(255)
#  num_rucom          :string(255)
#  rucomeable_type    :string(255)
#  rucomeable_id      :integer
#  trazoro            :boolean          default(FALSE), not null
#

# NOTE[DIEGO.GOMEZ]: This table was implemented thinking that Trazoro will have access
# to the RUCOM DB and then we won't need this table anymore.
# But after all this time, I think that it is better have this table here and replicate the
# rucom information even if they give us access to the DB, This way we can handle the rucom
# data in a better way and to improve the app performance as well.
class Rucom < ActiveRecord::Base

  belongs_to :rucomeable,  polymorphic: true

 # This method is just for clarfy the user activity related with gold.
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
