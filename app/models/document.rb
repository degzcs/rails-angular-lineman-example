# == Schema Information
#
# Table name: documents
#
#  id                :integer          not null, primary key
#  file              :string(255)
#  type              :string(255)
#  documentable_id   :string(255)
#  documentable_type :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Document < ActiveRecord::Base

  #
  # STI config
  #

  self.inheritance_column = 'sti_type'

  #
  # FIles
  #

  mount_uploader :file, DocumentUploader

  #
  # Associations
  #

  belongs_to :documentable, polymorphic: true

end
