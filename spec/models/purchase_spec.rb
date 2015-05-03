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
#  seller_picture              :string(255)
#  code                        :text
#  trazoro                     :boolean          default(FALSE), not null
#  sale_id                     :integer
#

require 'spec_helper'

describe Purchase, type: :model do

  let(:user){create(:user)}

  let(:gold_batch){create(:gold_batch)}

  let(:purchase){ build :purchase, user: user, gold_batch: gold_batch }

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

    context "test barcode generation" do

      before :each do
        purchase.save
        @code ="770#{purchase.user.id.to_s.rjust(5, '0') }#{ purchase.gold_batch_id.to_s.rjust(4, '0')}"
      end

    it "should generate a barcode when the purchase is  is created" do
      expect(purchase.reload.code).to eq @code
    end

    it "should generate a barcode when the purchase is  is created" do
      expect(purchase.reload.barcode_html).not_to be_nil
    end
  end

end
