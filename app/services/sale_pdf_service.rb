#This Generator get all the necesary values for the pdf service in order to create a sale report

class SaleCertificateGenerator
  def initialize(sale_id)
    @sale_id = sale_id
  end

 
  def provider 
    sale = Sale.find(@sale_id)
    user = sale.user
    {
      social: '',
      name: user.name + user. lastname,
      type: 'Usuario trazoro',
      identification_number: user.document_number,
      nit: '',
      rucom: user.rucom.num_rucom || user.rucom.rucom_record,
      address: user.address,
      email: user.email,
      phone: user.phone_number
    }
  end

end
