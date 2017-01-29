# encoding: utf-8
require 'carrierwave/processing/mime_types'

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include CarrierWave::CleanUpFolders
  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  if APP_CONFIG[:USE_AWS_S3] || Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Process
  process :set_content_type


  # Versions
  version :thumb do
    #process enable_processing: true
    process :convert => :jpg
    process resize_to_fit: [50, 50]
    process :quality => 100

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  version :medium do
    #process enable_processing: true
    process :convert => :jpg
    process resize_to_fit: [300, 300]
    process :quality => 85

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  # Callbacks
  after :remove, :delete_empty_upstream_dirs

  # Override the directory where uploaded files will be stored.
  def store_dir
    tmp_base_path = (APP_CONFIG[:USE_AWS_S3] || Rails.env.production?) ? "/uploads/photos/#{model.class.to_s.underscore}" : base_store_dir
    "#{ tmp_base_path }/#{ mounted_as }/#{ model.id }"
  end

  def base_store_dir
    "#{ Rails.root }/public/#{ Rails.env }/uploads/photos/#{model.class.to_s.underscore}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png pdf svg)
  end
end
