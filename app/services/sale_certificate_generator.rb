#This Generator joins all sold batches in one using the generate_certificate method

class SaleCertificateGenerator
  def initialize(sale)
    @sale = sale
    @certificate_files = []
  end

  def generate_certificate
    pupulate_origin_certificate_files
    system <<-COMMAND
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=#{Rails.root.join('tmp/certificate.pdf')} #{@certificate_files.join(' ')}
    COMMAND
    @sale.origin_certificate_file = Rails.root.join('tmp/certificate.pdf').open
    @sale.save!
  end

  private

  def pupulate_origin_certificate_files
    @sale.batches.each do|batch|
      purchase = Purchase.find(batch.purchase_id)
      @certificate_files << Rails.root.join("public"+purchase.origin_certificate_file.url).to_s
    end
  end

end
