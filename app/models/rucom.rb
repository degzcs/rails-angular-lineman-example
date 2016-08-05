# == Schema Information
#
# Table name: rucoms
#
#  id              :integer          not null, primary key
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

  # This method is just for clarfy the user activity related with gold.
  def activity
    provider_type
  end
end
