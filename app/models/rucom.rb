# == Schema Information
#
# Table name: rucoms
#
#  id              :integer          not null, primary key
#  rucom_number    :string(255)
#  name            :string(255)
#  original_name   :string(255)
#  minerals        :string(255)
#  location        :string(255)
#  status          :string(255)
#  provider_type   :string(255)
#  rucomeable_type :string(255)
#  rucomeable_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# NOTE[DIEGO.GOMEZ]: This table was implemented thinking that Trazoro will have access
# to the RUCOM DB and then we won't need this table anymore.
# But after all this time, I think that it is better have this table here and replicate the
# rucom information even if they give us access to the DB, This way we can handle the rucom
# data in a better way and to improve the app performance as well.
class Rucom < ActiveRecord::Base
  belongs_to :rucomeable, polymorphic: true
  # TODO: Currently these fields :rucomeable_type, :rucomeable_id cause some problems when they are add to attr_readonly method. So we decided to put them there in the next iterations and fix the specs related with them.
  attr_readonly :name, :minerals, :status, :provider_type, :original_name
  # This method is just for clarfy the user activity related with gold.
  def activity
    provider_type
  end

  def there_are_unset_attributes
    self.rucom_number.blank?
  end
end
