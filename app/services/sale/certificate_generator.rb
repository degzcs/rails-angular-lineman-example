#This Generator joins all sold batches in one unique pdf.
class Sale::CertificateGenerator
  attr_accessor :sale, :certificate_files

  def initialize(options={})
    @certificate_files = []
  end

  def call(options={})
    raise 'You must to set the sale option' if options[:sale].blank?
    @sale = options[:sale]
    @certificate_files = options[:certificate_files] || []

    temporal_file_location = if APP_CONFIG[:USE_AWS_S3] || Rails.env.production?
                              @certificate_files = origin_certificate_files_from_aws_s3
                              exec_commands_on_aws_s3!(options[:timestamp])
                            else
                              @certificate_files = origin_certificate_files_from_local_machine
                              exec_commands_on_local_machine!(options[:timestamp])
                            end

    sale.origin_certificate_file = open(temporal_file_location)
    sale.save!
  end

  #
  def exec_commands_on_local_machine!(timestamp=Time.now.to_i)
    final_temporal_file_name = "certificate-#{ timestamp }.pdf"
    folder_path = "#{ Rails.root }/tmp/#{ timestamp }"

    if create_temporal_folder(folder_path)
      join_files(folder_path, certificate_files, final_temporal_file_name)
    else
      raise 'The folder was not creted!'
    end
  end

  # TODO: check if it is better to use AWS Lambda instead to download
  # all files to the EC2 instance.
  # @return [ String ] with the temporal file location
  def exec_commands_on_aws_s3!(timestamp=Time.now.to_i)
    final_temporal_file_name = "certificate-#{ timestamp }.pdf"
    folder_path = "#{ Rails.root }/tmp/#{ timestamp }"

    if create_temporal_folder(folder_path)
      temporal_files = download_files!(folder_path, certificate_files)
      file_paths = temporal_files.map{ |file| file[:filename] }
      join_files(folder_path, file_paths, final_temporal_file_name)
    else
      raise 'The folder was not creted!'
    end
  end

  private

  # @param folder_path [ String ] where the files will be saved temporarily
  # @param temporal_files [ Array ] of Hashes
  # @param final_temporal_file_name [ String ]
  # @return [ String ] with the temporal file location
  def join_files(folder_path, file_paths, final_temporal_file_name)
    joined_file_paths = file_paths.join(' ')
    # NOTE: if it is needed you can add  -density 50 to the next command
    system <<-COMMAND
      cd #{ folder_path } && convert -format pdf #{ joined_file_paths } #{ final_temporal_file_name }
    COMMAND
    temporal_file_location = "#{ folder_path }/#{ final_temporal_file_name }"
  end

  # @param folder_path [ String ] where the files will be saved temporarily
  # @return [ Boolean ]
  def create_temporal_folder(folder_path)
    system <<-COMMAND
      mkdir -p #{ folder_path } && cd #{ folder_path }
    COMMAND
  end

  # @param folder_path [ String ] where the files will be saved temporarily
  # @param files [ Array ] of DocumentUploader instances
  # @return [ Hash ]
  def download_files!(folder_path, files)
    files.map do |file|
      filename = filename_from(file)
      {
        filename: filename,
        size: File.open("#{ folder_path }/#{ filename }", 'wb'){|f| f.write(file.read)}
      }
    end
  end

  # @param file [ DocumentUploader ]
  # @ return [ String ] with a temporal unique filename
  def filename_from(file)
    "#{ file.model.code }-#{ file.current_path.split('/').last }"
  end

  # Gets all origin certificate files from the current sale
  # @return [ Array ] of DocumentUploader
  def origin_certificate_files_from_aws_s3
    sale.batches.map{ |batch| batch.purchase.origin_certificate_file }
  end

  # Gets all origin certificate files from the current sale
  # @return [ Array ] of file paths
  def origin_certificate_files_from_local_machine
    sale.batches.map { |batch| Rails.root.join(batch.purchase.origin_certificate_file.path).to_s }
  end

  def purchase_files_from(purchase)
    # origin certificate
    purchase.origin_certificate_file.path
    # ID
    purchase.user.id_document_file
    # barequero id OR miner register OR resolution
    purchase.user.mining_register_file
    # purchase equivalent document
    purchase.proof_of_purchase.file
  end
end
