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

    def convert_pdf
        manipulate! do |img|
          img.format('pdf', 0) do |convert|
            convert << "-format"
            convert << "pdf"
          end
          img
        end
        # NOTE: force and override the content type. Becuase this when a images is upload
        # to amazon this produce a corruption in the PDF file.
        file.content_type='application/pdf'
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
    version :preview do
    process :convert => :jpg
    process :resize_to_fit => [310, 200]

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  version :pdf do
    process :convert_pdf
    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.pdf'
    end
  end


  # Callbacks
  after :remove, :delete_empty_upstream_dirs


  # Override the directory where uploaded files will be stored.
  def base_store_dir
    "#{ Rails.root }/public/#{ Rails.env }/uploads/documents/#{model.class.to_s.underscore}"
  end

  def store_dir
    tmp_base_path =  if (APP_CONFIG[:USE_AWS_S3] || Rails.env.production?)
        "/uploads/photos/#{model.class.to_s.underscore}"
      else
        base_store_dir
      end
    "#{ tmp_base_path }/#{ mounted_as }/#{ model.id }"
  end

  def cache_dir
    "#{Rails.root}/tmp/documents"
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
