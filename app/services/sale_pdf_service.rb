#This Generator get all the necesary values for the pdf service in order to create a sale report

class SalePDFService
  def initialize(sale_id)
    @sale =  ::Sale.find(sale_id)
  end


  def values
    { 
      provider: provider,
      buyer: buyer,
      carrier: carrier,
      purchase: purchase,
      batch: batch,
      certificate_path: certificate_path
    }
  end

 private

  def provider 
    user = @sale.user
    {
      social: '',
      name: user.first_name + user.last_name,
      type: 'Usuario trazoro',
      identification_number: user.document_number,
      nit: '',
      rucom: user.rucom.num_rucom || user.rucom.rucom_record,
      address: user.address,
      email: user.email,
      phone: user.phone_number
    }
  end

  def buyer
    client = Client.find(@sale.client_id)
    {
      social: '',
      name: client.first_name + client.last_name,
      type: 'Cliente trazoro',
      identification_number: client.id_document_number,
      nit: '',
      rucom: client.rucom.num_rucom || client.rucom.rucom_record,
      address: client.address,
      email: client.email,
      phone: client.phone_number
    }
  end

  def carrier
    courier = Courier.find(@sale.courier_id)
    {
      name: courier.first_name
    }

  end

  def purchase
    {
      price: @sale.price,
      law: @sale.grade ,
      grams: @sale.grams * 999 / @sale.grade,
      fine_grams: @sale.grams,
      code: @sale.code
    }
  end

  def batch
    batches = []
    @sale.batches.each do|b|
      p = Purchase.find(b.purchase_id)

      batches << {
        id_purchase: p.id,
        id_provider: p.provider.id,
        social: '',
        certificate_number: p.origin_certificate_sequence,
        rucom: '',
        fine_grams: p.gold_batch.grams
      }
    end
    batches
  end

  def certificate_path
    @sale.origin_certificate_file.url
  end
end
