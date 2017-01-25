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

  include CarrierWave::RMagick
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
  version :preview, if: :is_image_extension?
  version :thumb,   if: :is_image_extension?
  version :medium,  if: :is_image_extension?

  # Callbacks
  after :remove, :delete_empty_upstream_dirs

  def set_content_type
    super
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{base_store_dir}/#{mounted_as[0,5]}/#{model.id}"
  end

  def base_store_dir
    "uploads/documents/#{model.class.to_s.underscore}"
  end


  def cover
    manipulate! do |frame, index|
      frame if index.try(:zero?) # take only the first page of the file
    end
  end

  version :preview do
    #return  nil unless :has_image_extension
    process :convert => :jpg
    process :cover
    #process :resize_to_fill => [310, 200]
    process :resize_to_fit => [310, 200]

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  version :thumb do
    #return  nil unless :has_image_extension
    process :convert => :jpg
    process :cover
    process :resize_to_fit => [50, 50]
    process :quality => 100 

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  version :medium do
    #return  nil unless :has_image_extension
    process :convert => :jpg
    process :cover
    process :resize_to_fit => [300, 300]
    process :quality => 85 

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png pdf svg)
  end

  def is_image_extension? photo_file
    extension_white_list.reject {|x| x == 'pdf'}.include? File.extname(photo_file.filename)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
