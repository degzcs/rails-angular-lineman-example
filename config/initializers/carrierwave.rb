if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
  class AttachmentUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "#{Rails.root}/spec/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


end

CarrierWave.configure do |config|
  config.base_path = ''
end

end