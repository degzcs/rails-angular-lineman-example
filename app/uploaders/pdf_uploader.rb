# encoding: utf-8

class PdfUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include CarrierWave::CleanUpFolders

  # Choose what kind of storage to use for this uploader:
  if APP_CONFIG[:USE_AWS_S3] || Rails.env.production?
    storage :fog
  else
    storage :file
  end

  after :remove, :delete_empty_upstream_dirs

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{base_store_dir}/#{mounted_as}/#{model.id}"
  end

  def base_store_dir
    "uploads/documents/#{model.class.to_s.underscore}"
  end


  def cover
    manipulate! do |frame, index|
      frame if index.zero? # take only the first page of the file
    end
  end

  version :preview do
    process :cover
    process :resize_to_fill => [310, 200]
    process :convert => :jpg

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

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
