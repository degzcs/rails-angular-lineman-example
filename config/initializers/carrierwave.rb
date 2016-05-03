if APP_CONFIG[:USE_AWS_S3] || Rails.env.production?
  CarrierWave.configure do |config|
    # config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     APP_CONFIG[:AWS_S3_ACCESS_KEY_ID],                        # required
      aws_secret_access_key: APP_CONFIG[:AWS_S3_SECRET_ACCESS_KEY],                        # required
      region:                APP_CONFIG[:AWS_S3_REGION],
      # host:                  's3.example.com',             # optional, defaults to nil
      # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = APP_CONFIG[:AWS_S3_BUCKET_NAME]                          # required
    config.fog_public     = false                                        # optional, defaults to true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
  end

else

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
    config.base_path = ''
  end

  class PdfUploader < CarrierWave::Uploader::Base
    storage :file
    def store_dir
      "#{Rails.root}/spec/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  class PhotoUploader < CarrierWave::Uploader::Base
    storage :file

    def store_dir
      "#{Rails.root}/spec/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

end