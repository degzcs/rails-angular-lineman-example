# == Schema Information
#
# Table name: purchases
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  provider_id                 :integer
#  origin_certificate_sequence :string(255)
#  gold_batch_id               :integer
#  origin_certificate_file     :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  price                       :float
#

require 'spec_helper'

describe Purchase, type: :model do

  let(:purchase){ build :purchase}

  it 'has a valid factory' do
      should be_valid
  end

  it 'should save one origin certificate file' do
    file_path = "#{Rails.root}/spec/support/test_images/image.png"
    File.open(file_path){|f| purchase.origin_certificate_file = f}
    expect(purchase.save).to be true
    expect(purchase.origin_certificate_file.file.file).not_to eq nil
    purchase.origin_certificate_file.enable_processing = false
    purchase.origin_certificate_file.remove!
  end
end
