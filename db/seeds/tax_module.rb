CODE_ACTIVITIES = [
    {code:'01', name: 'Aporte especial para la administración de justicia.'},
    {code:'02', name: 'Gravamen a los movimientos financieros'},
    {code:'03', name: 'Impuesto al patrimonio'},
    {code:'04', name: 'Impuesto de renta y complementarios régimen especial'},
    {code:'05', name: 'Impuesto de renta y complementario régimen ordinario'},
    {code:'06', name: 'Ingresos y patrimonio.'},
    {code:'07', name: 'Retención en la fuente a título de renta'},
    {code:'08', name: 'Retención timbre nacional'},
    {code:'09', name: 'Retención en la fuente en el impuesto sobre las ventas'},
    {code:'10', name: 'Usuario aduanero'},
    {code:'11', name: 'Ventas régimen común'},
    {code:'12', name: 'Ventas régimen simplificado'},
    {code:'13', name: 'Gran contribuyente'},
    {code:'14', name: 'Informante de exógena'},
    {code:'15', name: 'Autorretenedor'},
    {code:'16', name: 'Obligación facturar por ingresos bienes y/o servicios excluidos'},
    {code:'17', name: 'Profesionales de compra y venta de divisas'},
    {code:'18', name: 'Precios de transferencia'},
    {code:'19', name: 'Productor de bienes y/o servicios exentos (incluye exportaciones)'},
    {code:'20', name: 'Obtención NIT'},
    {code:'21', name: 'Declarar ingreso o salida del país de divisas o moneda l'},
    {code:'22', name: 'Obligado a cumplir deberes formales a nombre de terceros'},
    {code:'23', name: 'Agente de retención en ventas'},
    {code:'24', name: 'Declaración consolidada precios de transferencia'},
    {code:'26', name: 'Declaración individual precios de transferencia'},
    {code:'32', name: 'Impuesto nacional a la gasolina y al ACPM'},
    {code:'33', name: 'Impuesto nacional al consumo'},
    {code:'34', name: 'Régimen simplificado impuesto nacional consumo res y bar'},
    {code:'35', name: 'Impuesto sobre la renta para la equidad - CREE.'},
    {code:'36', name: 'Establecimiento Permanente'},
    {code:'40', name: 'Impuesto a la Riqueza'},
    {code:'41', name: 'Declaración anual de activos en el exterior'},
    {code:'42', name: 'Obligado a llevar contabilidad'}
  ]

puts 'Begin to load the Rut activity codes'

CODE_ACTIVITIES.each do |reg|
  RutActivity.where(code: reg[:code], name: reg[:name]).first_or_create
end

puts 'End to load the Rut activity codes'