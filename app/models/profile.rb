# == Schema Information
#
# Table name: profiles
#
#  id                        :integer          not null, primary key
#  document_number           :string(255)
#  phone_number              :string(255)
#  avaible_credits           :float
#  address                   :string(255)
#  rut_file                  :string(255)
#  photo_file                :string(255)
#  mining_authorization_file :text
#  legal_representative      :boolean
#  id_document_file          :text
#  nit_number                :integer
#  city_id                   :integer
#  created_at                :datetime
#  updated_at                :datetime
#

class Profile < ActiveRecord::Base
  belongs_to :city


end
