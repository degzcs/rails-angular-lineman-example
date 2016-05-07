#This Generator joins all sold batches in one using the generate_certificate method
class Sale::CertificateGenerator
  attr_accessor :sale, :certificate_files

  def initialize(options={})
    @certificate_files = []
  end

  def call(options={})
    @sale = options[:sale]
    @certificate_files = options[:certificate_files] || []

    pupulate_origin_certificate_files
    temporal_file_location = exec_command!
    sale.origin_certificate_file = open(temporal_file_location)
    sale.save!
  end

  # @return [ String ] with the temporal file location
  def exec_command!
    temporal_file_name = "certificate-#{Time.now.to_i}.pdf"
    temporal_file_location = "#{Rails.root}/tmp/#{temporal_file_name}"
    # NOTE: if it is needed you can add  -density 50 to the next command
    system <<-COMMAND
      convert -format pdf #{ certificate_files.join(' ') } #{ temporal_file_location }
    COMMAND
    temporal_file_location
  end

  private

  # Gets al origin certificate files from the current sale
  def pupulate_origin_certificate_files
    sale.batches.each do|batch|
      purchase = Purchase.find(batch.purchase_id)
      certificate_files << Rails.root.join(purchase.origin_certificate_file.path).to_s
    end
  end
end
