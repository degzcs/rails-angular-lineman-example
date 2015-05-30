# == Schema Information
#
# Table name: sales
#
#  id                      :integer          not null, primary key
#  courier_id              :integer
#  client_id               :integer
#  user_id                 :integer
#  gold_batch_id           :integer
#  code                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  origin_certificate_file :string(255)
#  price                   :float
#  trazoro                 :boolean
#

FactoryGirl.define do
  factory :sale do
    courier
    user
    client_id {FactoryGirl.create(:external_user).id}
    gold_batch
    code       "12345677"
    price 123214521
    origin_certificate_file {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_pdfs', 'origin_certificate_file.pdf'))}
  end
end
