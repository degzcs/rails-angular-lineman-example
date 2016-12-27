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

puts '0- Begin to load the Rut activity codes'

CODE_ACTIVITIES.each do |reg|
  RutActivity.where(code: reg[:code], name: reg[:name]).first_or_create
end

puts 'End to load the Rut activity codes successfully'

puts '1- Create Puc accounts to Tax Module'

puc_array = [
  ["130505","Clientes Nacionales"],
  ["135595","ANTICIPO CREE (.40%)"],
  ["23657501","Autorretención CREE"],
  ["23657502","Autorretención RTFTE (2.5%)"],
  ["413595","Ingresos por Venta de Oro"],
  ["613516","Venta Materias Primas Oro"],
  ["140501","Materias Primas Oro"],
  ["111005","Moneda Nacional"],
  ["240804","Impuesto sobre las ventas por pagar(16%)"],
  ["135518","ICA retenido (1% Medellín)"],
  ["135515","Retención en la fuente (2.5%)"],
  ["240802","Impuesto a las ventas en compras (16%)"],
  ["236540","Retención en compras (2.5)"],
  ["236740","IVA retenido en compras (2.4%)"],
  ["236840","ICA retenido en compras (1% Medellín)"],
  ["220505","Proveedores Nacionales"],
  ["135517","IVA retnido (2.4%)"],
  ["429515","Regalias (4%)"],
  ["511595","Impuestos retención en la fuente (3.5%)"],
  ["511505","Impuesto ICA retenido (1% Medellín)"]
]

puc_array.each do |e|
  PucAccount.where(
    code: e[0],
    name: e[1]
  ).first_or_create
end


puts '2- Create Taxes to Tax Module'

tax_array = [
  ["Anticipo CREE", "ANT_CREE", 0.4, PucAccount.find_by(code: '135595').id],
  ["Autorretención CREE", "AUT_CREE", 0.4, PucAccount.find_by(code: '23657501').id],
  ["Retención en la Fuente (2.5%)", "RTFTE_2.5", 2.5, PucAccount.find_by(code: '135515').id],
  ["Regalias (4%)", "REGALIAS", 4, PucAccount.find_by(code: '429515').id],
  ["IVA entre RS y RC (2.4%)", "IVA_2.4", 2.4, PucAccount.find_by(code: '240804').id],
  ["ICA entre RS y GC (1%)", "ICA_1", 1, PucAccount.find_by(code: '511505').id],
  ["Impuestos retención en la fuente RS y GC (3.5%)", "RTFTE_3.5", 3.5, PucAccount.find_by(code: '511505').id]
]

tax_array.each do |e|
  Tax.where(
    name: e[0],
    reference: e[1],
    porcent: e[2],
    puc_account_id: e[3]
  ).first_or_create
end

puts '3- Create tax rules'

tax_rules_array = [
  [Tax.find_by(reference: 'ANT_CREE').id,"RC","GC"],
  [Tax.find_by(reference: 'AUT_CREE').id,"RC","GC"],
  [Tax.find_by(reference: 'IVA_2.4').id,"RS","RC"],
  [Tax.find_by(reference: 'REGALIAS').id,"RS","RC"],
  [Tax.find_by(reference: 'RTFTE_3.5').id,"RS","GC"],
  [Tax.find_by(reference: 'ICA_1').id,"RS","GC"]
]

tax_rules_array.each do |e|
  TaxRule.where(
    tax_id: e[0],
    seller_regime: e[1],
    buyer_regime: e[2],
  ).first_or_create
end

puts '4- Create transaction movements to see the sale transaction taxes report'

transaction_movement_array = [
  [PucAccount.find_by(code: '130505').id, "sale", "movements", 'D'],
  [PucAccount.find_by(code: '135515').id, "sale", "taxes", 'D'],
  [PucAccount.find_by(code: '135595').id, "sale", "taxes", 'D'],
  [PucAccount.find_by(code: '23657502').id, "sale", "taxes", 'C'],
  [PucAccount.find_by(code: '23657501').id, "sale", "taxes", 'C'],
  [PucAccount.find_by(code: '413595').id, "sale", "movements", 'C'],
  [PucAccount.find_by(code: '240804').id, "purchase", "taxes", 'C'],
  [PucAccount.find_by(code: '613516').id, "sale", "inventories", 'D'],
  [PucAccount.find_by(code: '140501').id, "sale", "inventories", 'C'],
  [PucAccount.find_by(code: '111005').id, "sale", "payments", 'D'],
  [PucAccount.find_by(code: '130505').id, "sale", "payments", 'C'],

  [PucAccount.find_by(code: '140501').id, "purchase", "movements", 'D'],
  [PucAccount.find_by(code: '240802').id, "purchase", "taxes", 'D'],
  [PucAccount.find_by(code: '236540').id, "purchase", "taxes", 'C'],
  [PucAccount.find_by(code: '236740').id, "purchase", "taxes", 'C'],
  [PucAccount.find_by(code: '220505').id, "purchase", "movements", 'C'],
  [PucAccount.find_by(code: '220505').id, "purchase", "payments", 'D'],
  [PucAccount.find_by(code: '111005').id, "purchase", "payments", 'C']
]

transaction_movement_array.each do |e|
  TransactionMovement.where(
    puc_account_id: e[0],
    type: e[1],
    block_name: e[2],
    afectation: e[3]
  ).first_or_create
end

puts 'Done!'
