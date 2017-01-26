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


class DocumentUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include CarrierWave::CleanUpFolders
  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  if APP_CONFIG[:USE_AWS_S3] || Rails.env.production?
    storage :fog
  else
    storage :file
  end

  #
  # Process
  #

  process :set_content_type

  # Versions
  version :preview, :if => :is_image_extension? do
    process :convert => :jpg
    process :cover
    #process :resize_to_fill => [310, 200]
    process :resize_to_fit => [310, 200]

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  version :thumb, :if => :is_image_extension? do
    process :convert => :jpg
    process :cover
    process :resize_to_fit => [50, 50]
    process :quality => 100

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  version :medium, :if => :is_image_extension? do
    process :convert => :jpg
    process :cover
    process :resize_to_fit => [300, 300]
    process :quality => 85

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  # Callbacks
  after :remove, :delete_empty_upstream_dirs


  # Override the directory where uploaded files will be stored.
  def store_dir
    "#{ base_store_dir }/#{ mounted_as }/#{ model.id }"
  end

  def base_store_dir
    "#{ Rails.root }/public/#{ Rails.env }/uploads/documents/#{model.class.to_s.underscore}"
  end

  def cover
    manipulate! do |frame, index|
      frame if index.try(:zero?) # take only the first page of the file
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png pdf svg)
  end

  # NOTE: This will never work for :version look at the https://github.com/carrierwaveuploader/carrierwave/blob/master/lib/carrierwave/uploader/versions.rb line 158, in that place is the only part where is used the :if condition but the version is built already in the previous method. For me it does not make sense.
  def is_image_extension?(new_file)
    new_file.content_type.start_with? 'image'
  end
end
