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

FactoryGirl.define do
  factory :document, :class => 'Documents' do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'documento_equivalente_de_compra'),"application/pdf") }
    type { ['invoice', 'receipt', 'equivalent_document'] } # TODO: pending create document type model
  end

end
