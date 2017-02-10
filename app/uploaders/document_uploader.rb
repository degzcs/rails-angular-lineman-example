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
      # binding.pry
        output = "#{current_path.split('.').first}.pdf"
        manipulate! do |img|
          ::MiniMagick::Tool::Convert.new do |convert|
            convert << current_path
            convert.merge! ["-format", "pdf"]
            convert << output
          end
          # binding.pry
          ::MiniMagick::Image.open(output)
        end
        # current_path = output
        # file= CarrierWave::SanitizedFile.new File.open(current_path)
        # img = ::MiniMagick::Image.open(current_path)
        # img.write(current_path)
        # img.run_command("identify", current_path)
        # img
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
  # process :resize_to_fit => [310, 200]

  # Versions
  version :pdf do
    process :convert_pdf

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.pdf'
    end
  end

  version :preview do
    process :convert => :jpg
    process :cover
    #process :resize_to_fill => [310, 200]
    process :resize_to_fit => [310, 200]

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
    "#{ Rails.root }/public/#{ Rails.env }/uploads/documents/#{model.class.to_s.underscore}"
  end

  def cover
    # TODO: check what is happening with this in dev and production
    # manipulate! do |frame, index|
    #   frame if index.try(:zero?) # take only the first page of the file
    # end
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
