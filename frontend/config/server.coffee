### Define custom server-side HTTP routes for lineman's development server
#   These might be as simple as stubbing a little JSON to
#   facilitate development of code that interacts with an HTTP service
#   (presumably, mirroring one that will be reachable in a live environment).
#
# It's important to remember that any custom endpoints defined here
#   will only be available in development, as lineman only builds
#   static assets, it can't run server-side code.
#
# This file can be very useful for rapid prototyping or even organically
#   defining a spec based on the needs of the client code that emerge.
#
###

module.exports = drawRoutes: (app) ->
  #
  # Auth
  #
  app.post '/api/v1/auth/login', (req, res) ->
    res.json {
      access_token: 'super_save_token',
      id: 1,
      first_name: 'Just',
      last_name: 'Incase',
      email: 'just.incase@fake.com',
    }


  app.post '/logout', (req, res) ->
    res.json message: 'logging out!'

  #
  #  Inventory
  #

  # GET
  # it is a possible route for the inventory (it is inventory or inventories ?)
  app.get '/api/v1/inventory', (req, res) ->
    list = []
    i = 0
    while i < 10
      inventory_item =
        date: ''
        hour: ''
        quien: '' # NOTE: is this the person that created a inventory?
        cuantos: '' # ?
        law: ''
        value: ''
      inventory_item.selected = false
      inventory_item.date = '10/20/2014' + i
      inventory_item.hour = '10:20' + i
      inventory_item.quien = 'Carlos R' + i # TODO: change name
      inventory_item.cuantos = i # TODO: change name
      inventory_item.law = '100' + i
      inventory_item.value = '100' + i
      list.push inventory_item
      i++
    console.log 'inventory list from the fake server ...'

    res.json {
      list: list,
      access_token: 'super_save_token'
    }

  #
  # Transporter
  #

  # POST
  # Create a transoporter
  app.post '/api/v1/transporter', (req, res) ->
    console.log('trasporter created... yay!!!')
    console.log('parameters: >> ' + req.params)
    res.json {
      name: 'Pepito',
      document_number: '123456789',
      phone: '+57300214587',
      address: 'calle falsa # 12 -3',
      email: 'pepito@fake.com',
      access_token: 'super_save_token'
    }

  # I know the following declaration may not be a good practice... but it's just temporal
  providerList = [
    {
      thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png',
      name: 'Diego Caicedo',
      id: '9800000-1',
      mineral: 'Oro',
      num_rucom: '',
      rucom_record: 'ARE_001_ABC',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction_date: '1427226977293',
      provider_type: 2,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'diego.caicedo@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh4.googleusercontent.com/-wx3BmJUhhpE/AAAAAAAAAAI/AAAAAAAAACM/R6R-aAQB62E/photo.jpg',
      name: 'Andres Maya',
      id: '9800000-2',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201503014886',
      rucom_record: '',
      rucom_status: 'Certificado',
      last_transaction_date: '1427226977300',
      provider_type: 3,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'andres.maya@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh4.googleusercontent.com/-MPs16CJ6ZBI/AAAAAAAAAAI/AAAAAAAAAfw/qZNidz7KVvo/photo.jpg',
      name: 'Carlos Mejía',
      id: '9800000-3',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201403014887',
      rucom_record: '',
      rucom_status: 'Certificado',
      last_transaction_date: '1427226978293',
      provider_type: 4,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'carlos.mejia@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh3.googleusercontent.com/-7qT3MgVr0rk/AAAAAAAAAAI/AAAAAAAAAJE/i1Yc_rFyVz8/photo.jpg',
      name: 'Camilo Pedraza',
      id: '9800000-4',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201303014890',
      rucom_record: '',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction_date: '1427226977493',
      provider_type: 5,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'camilo.pedraza@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh3.googleusercontent.com/-xUqWqzQQaZc/AAAAAAAAAAI/AAAAAAAAA88/M5EhGqXSItk/photo.jpg',
      name: 'Jesus Muñoz',
      id: '9800000-5',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201503014892',
      rucom_record: '',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction_date: '1427226977600',
      provider_type: 6,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'jesus.munoz@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh6.googleusercontent.com/-KAhFBi4grKU/AAAAAAAAAAI/AAAAAAAABLM/hnWGNvV7D2k/photo.jpg',
      name: 'Esteban Cerón',
      id: '9800000-6',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201203014810',
      rucom_record: '',
      rucom_status: 'Certificado',
      last_transaction_date: '1427226977550',
      provider_type: 7,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'esteban.ceron@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://plus.google.com/u/0/_/focus/photos/public/AIbEiAIAAABECOnz4JakhaOK_gEiC3ZjYXJkX3Bob3RvKihiMWQyMWNkZmRiYzIzM2EzODUyZDQyMjU3ZWVlZTU4MzU0MWE3ZjY3MAFLUhAwq57N0mPOSXuYPdiOmJZ9KQ?sz=48',
      name: 'Juan Cerón',
      id: '9800000-7',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201303014800',
      rucom_record: '',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction_date: '1427226978293',
      provider_type: 1,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'juan.ceron@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh3.googleusercontent.com/-q9i8c2WHh9I/AAAAAAAAAAI/AAAAAAAAAK0/p9wFW0PJ_oo/photo.jpg',
      name: 'Diego Gómez',
      id: '9800000-8',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201403014802',
      rucom_record: '',
      rucom_status: 'Certificado',
      last_transaction_date: '1427226977893',
      provider_type: 2,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'diego.gomez@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh4.googleusercontent.com/-kzZKDrB6wb4/AAAAAAAAAAI/AAAAAAAAAzU/CnnUA5Ygbjs/photo.jpg',
      name: 'Javier Suarez',
      id: '9800000-9',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201303014201',
      rucom_record: '',
      rucom_status: 'Certificado',
      last_transaction_date: '1427226979293',
      provider_type: 3,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'javier.suarez@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh5.googleusercontent.com/-K1ZinAJG6D0/AAAAAAAAAAI/AAAAAAAAAGk/vFy0NwAptgI/photo.jpg',
      name: 'Luis Rojas',
      id: '9800001-0',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201403014833',
      rucom_record: '',
      rucom_status: 'Certificado',
      last_transaction_date: '1427226977777',
      provider_type: 4,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'luis.rojas@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://lh4.googleusercontent.com/-9pJ7LbpZ_nA/AAAAAAAAAAI/AAAAAAAAFuc/VxoI6yvIzlE/photo.jpg',
      name: 'Leandro Ordóñez',
      id: '1023939222',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201403014943',
      rucom_record: '',
      rucom_status: 'Certificado',
      last_transaction_date: '1427227113631',
      provider_type: 5,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'leandro.ordonez.ante@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png',
      name: 'Conrado Franco',
      id: '9800001-2',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201503204884',
      rucom_record: '',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction_date: '1427227123631',
      provider_type: 6,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'conrado.franco@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png',
      name: 'José Valdovino',
      id: '9800001-3',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201503204883',
      rucom_record: '',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction_date: '1427227133631',
      provider_type: 7,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'jose.valdovino@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    },{
      thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png',
      name: 'Sandis Martinez',
      id: '9800001-4',
      mineral: 'Oro',
      num_rucom: 'RUCOM-201503194882',
      rucom_record: '',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction_date: '1427227113731',
      provider_type: 1,
      type: 'Persona Natural',
      phone_nb: '314 757 9454',
      address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
      email: 'sandis.martinez@gmail.com',
      city: 'Popayán',
      state: 'CAUCA',
      postalCode : '94043'
    }
  ];

  #
  #  provider
  #

  # GET
  # it is a possible route for the provider
  app.get '/api/v1/provider', (req, res) ->
    console.log 'provider list from the fake server ...'

    res.json {
      list: providerList,
      access_token: 'super_save_token'
    }

  # GET
  # endpoint for retrieving providers by ID
  app.get '/api/v1/provider/:providerId', (req, res) ->
    console.log 'retrieving provider ' + req.params.providerId + ' from the fake server ...'
    provider = {}
    for p of providerList
      if providerList[p].id == req.params.providerId
        provider = providerList[p]
        break
    res.json {
      provider: provider,
      access_token: 'super_save_token'
    }

  #
  #  Purchase
  #

  # POST
  # endpoint for save purchase
   app.post '/api/v1/purchases/', (req, res) ->
    console.log 'params ' + req.params
    res.json {
      purchase: 'purchase info',
      access_token: 'super_save_token'
    }

  # GET
  # endpoint for retrieving providers by ID
  app.get '/api/v1/provider/:providerId', (req, res) ->
    console.log 'retrieving provider ' + req.params.providerId + ' from the fake server ...'
    provider = {}
    for p of providerList
      if providerList[p].id == req.params.providerId
        provider = providerList[p]
        break
    res.json {
      provider: provider,
      access_token: 'super_save_token'
    }

  rucoms_reg = [
    {
      idrucom:"ARE_PLT-16451&JUAN_NEPOMUCENO_ROJAS_MARQ",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JUAN NEPOMUCENO ROJAS MARQUEZ",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:22"
    },
    {
      idrucom:"ARE_PLT-15121&MANJARRES_GELVEZ_VICTOR_MA",
      num_rucom:"",
      rucom_record:"ARE_PLT-15121",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MANJARRES GELVEZ VICTOR MANUEL",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SARDINATA-NORTE SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:22"
    },
    {
      idrucom:"ARE_PLU-08141&MANUEL_ANTONIO_VASQUEZ_DEL",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MANUEL ANTONIO VASQUEZ DELGADO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&LEON_CARVAJAL_LUIS_GABRIEL",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"LEON CARVAJAL LUIS GABRIEL",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-10411&HECTOR_ALONSO_MORENO_QUITI",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HECTOR ALONSO MORENO QUITIAN",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-15121&GELVEZ_BRIGIDO_MANJARRES",
      num_rucom:"",
      rucom_record:"ARE_PLT-15121",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"GELVEZ BRIGIDO MANJARRES",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SARDINATA-NORTE SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-10411&MILTON_ANTONIO_TELLEZ_BURG",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MILTON ANTONIO TELLEZ BURGOS",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&FREDY_ALEXANDER_MENDIVELSO",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"FREDY ALEXANDER MENDIVELSO MONTOYA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-10411&GERARDO_MARIN_RODRIGUEZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"GERARDO MARIN RODRIGUEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&JUAN_NEPOMUCENO_ESTUPINAN_",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JUAN NEPOMUCENO ESTUPINAN GARCIA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-15121&RICARDO_MONTOYA_DELGADO",
      num_rucom:"",
      rucom_record:"ARE_PLT-15121",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"RICARDO MONTOYA DELGADO",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SARDINATA-NORTE SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&DE_MOJICA_CARMEN_ROSA_TOSC",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"DE MOJICA CARMEN ROSA TOSCANO",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-15121&MOISES_QUINTERO_BARAJAS",
      num_rucom:"",
      rucom_record:"ARE_PLT-15121",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MOISES QUINTERO BARAJAS",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SARDINATA-NORTE SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JOSE_ELADIO_CORRALES_PEROZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE ELADIO CORRALES PEROZA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&JOSE_ARISTIPO_DUARTE_SILVA",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE ARISTIPO DUARTE SILVA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&JOSE_TOBIAS_ROJAS_MARQUEZ",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE TOBIAS ROJAS MARQUEZ",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&HERNANDO_DE_JESUS_ORTIZ_SO",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HERNANDO DE JESUS ORTIZ SOLANO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&LUIS_ADRIAN_ORTIZ_CHACON",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"LUIS ADRIAN ORTIZ CHACON",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&GERMAN_ENRIQUE_PALACIOS_VI",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"GERMAN ENRIQUE PALACIOS VILLALOBOS",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&HERNANDO_DE_JESUS_MEJIA_LO",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HERNANDO DE JESUS MEJIA LOPEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JHON_ALEXANDER_PRADA_CASTA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JHON ALEXANDER PRADA CASTAÑEDA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&GUSTAVO_DE_JESUS_RODRIGUEZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"GUSTAVO DE JESUS RODRIGUEZ VIVARES",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JESUS_HUMBERTO_SANTA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JESUS HUMBERTO SANTA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&ELIECER_ALEXANDER_ESTUPIÑA",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ELIECER ALEXANDER ESTUPIÑAN GARCIA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&NELSON_ESTEBAN_BERNAL_SANT",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"NELSON ESTEBAN BERNAL SANTA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-10411&ALVEIRO_MMATEUS",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ALVEIRO MMATEUS",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&ROSA_MARIA_CELY_RINCON",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ROSA MARIA CELY RINCON",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&JOHN_DANILO_MENDIVELSO_MON",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOHN DANILO MENDIVELSO MONTOYA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&JUAN_SANTOS_CELY",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JUAN SANTOS CELY",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&SEGUNDO_EFRAIN_PARRA_MONTA",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"SEGUNDO EFRAIN PARRA MONTAÑEZ",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&EDIBERTO_CUSBA",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"EDIBERTO CUSBA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&LUIS_ANGARITA_MARTINEZ",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"LUIS ANGARITA MARTINEZ",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&BUENAVENTURA_ROJAS_MURCIA",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"BUENAVENTURA ROJAS MURCIA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-10411&LUZ_MARITZA_MARIN_SANTAMAR",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"LUZ MARITZA MARIN SANTAMARIA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-10411&BELISARIO_SUATERNA_PEÑA",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"BELISARIO SUATERNA PEÑA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-11301&JAVIER_SUAREZ_CAICEDO",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JAVIER SUAREZ CAICEDO",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&EDWIN_ENRIQUE_MELDIVELSO_M",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"EDWIN ENRIQUE MELDIVELSO MONTOYA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&MARÍA_RAMOS_ANGARITA",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MARÍA RAMOS ANGARITA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&JAIME_MELO",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JAIME MELO",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&RAFAEL_ANTONIO_NIÑO_PANQUE",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"RAFAEL ANTONIO NIÑO PANQUEVA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-09281&JORGE_ELIECER_RINCÓN_VARGA",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JORGE ELIECER RINCÓN VARGAS",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&CARLOS_ALIRIO_ESTUPIÑAN_GA",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CARLOS ALIRIO ESTUPIÑAN GARCÍA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&JOSE_JOAQUIN_ESTUPIÑAN_GAR",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE JOAQUIN ESTUPIÑAN GARCÍA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLT-16451&ENEPTALÍ_ESTUPIÑAN_GARCÍA",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ENEPTALÍ ESTUPIÑAN GARCÍA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&FAIDIBER_DE_JESÚS_GUARDIA_",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"FAIDIBER DE JESÚS GUARDIA ALBORNOZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JHONATAN_NELSON_BERNAL_PER",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JHONATAN NELSON BERNAL PEREZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&LUIS_FERNANDO_MEJIA_RUA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"LUIS FERNANDO MEJIA RUA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&YEN_FERNEY_TUNDERO_GONZALE",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"YEN FERNEY TUNDERO GONZALEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&MARIO_BERNAL_SANTA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MARIO BERNAL SANTA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JOSE_ÁLVARO_CARDONA_POSADA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE ÁLVARO CARDONA POSADA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&HERNANDO_DE_JESÚS_ORTIZ_CH",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HERNANDO DE JESÚS ORTIZ CHACÓN",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&DANIEL_ALBERTO_ORTIZ_CHACÓ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"DANIEL ALBERTO ORTIZ CHACÓN",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JHON_JAIRO_SANDOVAL_RODRIG",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JHON JAIRO SANDOVAL RODRIGUEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&FREIMER_ALEXANDER_SANTA_VÉ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"FREIMER ALEXANDER SANTA VÉLEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JOSE_MARINO_MOSQUERA_MOSQU",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE MARINO MOSQUERA MOSQUERA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&MANUEL_CARO",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MANUEL CARO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&EVELIO_BEJARANO_AYALA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"EVELIO BEJARANO AYALA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&WILLIAM_MANUEL_MESA_AMAYA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"WILLIAM MANUEL MESA AMAYA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&LUIS_FERNANDO_CARDONA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"LUIS FERNANDO CARDONA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&DAIRO_ARCINIEGAS_GONZALEZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"DAIRO ARCINIEGAS GONZALEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JOAQUÍN_ANTONIO_REYES_MONT",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOAQUÍN ANTONIO REYES MONTES",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&LUS_ALFREDO_DUARTE_ZAPATA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"LUS ALFREDO DUARTE ZAPATA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&DIOGENES_ARMANDO_ÁLVAREZ_R",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"DIOGENES ARMANDO ÁLVAREZ RIVERA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&CARLOS_ALBERTO_HERRERA_SAN",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CARLOS ALBERTO HERRERA SANCHEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&ANDRES_MONTOYA_RESTREPO",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ANDRES MONTOYA RESTREPO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&NIXON_ESCOBAR_SALAZAR",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"NIXON ESCOBAR SALAZAR",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&SALVADOR_DE_JESUS_GONZALEZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"SALVADOR DE JESUS GONZALEZ GARCÍA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JOHN_EDISON_ARCINIEGAS_GON",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOHN EDISON ARCINIEGAS GONZALEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&WILMAR_ARCINIEGAS_GONZALEZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"WILMAR ARCINIEGAS GONZALEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&HERNÁN_DARIO_SERRANO_RUA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HERNÁN DARIO SERRANO RUA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&EMIRO_ANTONIO_PIMIENTA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"EMIRO ANTONIO PIMIENTA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&DAIRO_CASTAÑEDA_HENAO",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"DAIRO CASTAÑEDA HENAO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&JHOAN_CAMILO_VELEZ_VERGARA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JHOAN CAMILO VELEZ VERGARA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&DARIO_ANTONIO_GUEVARA_VALE",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"DARIO ANTONIO GUEVARA VALENCIA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:23"
    },
    {
      idrucom:"ARE_PLU-08141&YOHN_HUVER_POSADA_REYES",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"YOHN HUVER POSADA REYES",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&HENRY_MANUEL_MOLINA_SANCHE",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HENRY MANUEL MOLINA SANCHEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&MALCON_ANTONIO_ORTÍZ_CHACÓ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MALCON ANTONIO ORTÍZ CHACÓN",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&JOSE_NORBEY_GALLEGO_OCAMPO",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE NORBEY GALLEGO OCAMPO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&INGERMAN_ALONSO_PIEDRAHITA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"INGERMAN ALONSO PIEDRAHITA ROJO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&JORGE_IVÁN_CASTAÑO_GAVIRIA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JORGE IVÁN CASTAÑO GAVIRIA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&FABIAN_BEDOYA_VÉLEZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"FABIAN BEDOYA VÉLEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&JOSE_DAIRO_SEPÚLVEDA_VALEN",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE DAIRO SEPÚLVEDA VALENCIA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&PEDRO_NEL_GALENO_MEJIA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"PEDRO NEL GALENO MEJIA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&JOSE_ALDEMAR_PALACIOS_VILL",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE ALDEMAR PALACIOS VILLALOBOS",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&GERMAN_VILLAREAL",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"GERMAN VILLAREAL",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&IVÁN_DARIO_MEJIA_GRAJALES",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"IVÁN DARIO MEJIA GRAJALES",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&FERNEY_HERNANDEZ_LARA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"FERNEY HERNANDEZ LARA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&RICAURTE_ALFREDO_SANTA_GIR",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"RICAURTE ALFREDO SANTA GIRALDO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&JOSE_FERNANDO_CORRALES_PER",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE FERNANDO CORRALES PEROZA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&CARLOS_ARTURO_VIRGUEZ_POSA",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CARLOS ARTURO VIRGUEZ POSADA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&JUAN_BAUTISTA_VÉLEZ_VERGAR",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JUAN BAUTISTA VÉLEZ VERGARA",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-08141&CESAR_ANDRES_SUAREZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-08141",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CESAR ANDRES SUAREZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"PUERTO NARE (LA MAGDALENA)-ANTIOQUIA\\ PUERTO BOYACA-BOYACA\\ PUERTO TRIUNFO-ANTIOQUIA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-10181&LUIS_GERARDO_NARVÁEZ_MORAL",
      num_rucom:"",
      rucom_record:"ARE_PLU-10181",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"LUIS GERARDO NARVÁEZ MORALES",
      status:"",
      mineral:"MINERALES DE ORO Y SUS CONCENTRADOS",
      location:"LA LLANADA-NARIÑO",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-10181&JOSE_IGNACIO_ROJAS_ÁLVAREZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-10181",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE IGNACIO ROJAS ÁLVAREZ",
      status:"",
      mineral:"MINERALES DE ORO Y SUS CONCENTRADOS",
      location:"LA LLANADA-NARIÑO",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-10181&HECTOR_GERARDO_CADENA_CANA",
      num_rucom:"",
      rucom_record:"ARE_PLU-10181",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HECTOR GERARDO CADENA CANAMEJOY",
      status:"",
      mineral:"MINERALES DE ORO Y SUS CONCENTRADOS",
      location:"LA LLANADA-NARIÑO",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-10411&MARCO_TULIO_MATEUS_TÉLLEZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MARCO TULIO MATEUS TÉLLEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-10411&JHON_JAIRO_QUIROGA_VARGAS",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JHON JAIRO QUIROGA VARGAS",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-10411&CARLOS_ARTURO_MARÍN_RODRÍG",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CARLOS ARTURO MARÍN RODRÍGUEZ",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-10411&ALIRIO_MEDINA_FRANCO",
      num_rucom:"",
      rucom_record:"ARE_PLU-10411",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ALIRIO MEDINA FRANCO",
      status:"",
      mineral:"MATERIALES DE CONSTRUCCIÓN",
      location:"LA BELLEZA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&HERMES_ORTÍZ_BALAGUERA",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HERMES ORTÍZ BALAGUERA",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&MANUEL_JAIMES_CARRILLO",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MANUEL JAIMES CARRILLO",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&JESÚS_MARÍA_MARTÍNEZ_MEJÍA",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JESÚS MARÍA MARTÍNEZ MEJÍA",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&ROSALBINA_BARRERA_BASTOS",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ROSALBINA BARRERA BASTOS",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&MARIO_GÓMEZ_VALBUENA",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MARIO GÓMEZ VALBUENA",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&REYNALDO_CÁRDENAS_HORMIGA",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"REYNALDO CÁRDENAS HORMIGA",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&REBECA_SANTANDER_DE_CÁRDEN",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"REBECA SANTANDER DE CÁRDENAS",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&CÉSAR_AUGUSTO_CÁRDENAS_SAN",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CÉSAR AUGUSTO CÁRDENAS SANTANDER",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&MARCO_FIDEL_SEPÚLVEDA_PINZ",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MARCO FIDEL SEPÚLVEDA PINZÓN",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&CARLOS_SEPÚLVEDA_PINZÓN",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CARLOS SEPÚLVEDA PINZÓN",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&MARIA_DEL_R_BLANCO_MONGUI",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MARIA DEL R BLANCO MONGUI",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&ARTURO_SOLANO_CÁRDENAS",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ARTURO SOLANO CÁRDENAS",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-12371&HUGO_VICENTE_CASAS_VARGAS",
      num_rucom:"",
      rucom_record:"ARE_PLU-12371",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"HUGO VICENTE CASAS VARGAS",
      status:"",
      mineral:"ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"RAQUIRA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-12371&MARÍA_LUCIA_CASTILLO_SILVA",
      num_rucom:"",
      rucom_record:"ARE_PLU-12371",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"MARÍA LUCIA CASTILLO SILVA",
      status:"",
      mineral:"ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"RAQUIRA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-12371&JOSE_HECTOR_HERNAN_PAEZ_VA",
      num_rucom:"",
      rucom_record:"ARE_PLU-12371",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE HECTOR HERNAN PAEZ VARGAS",
      status:"",
      mineral:"ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"RAQUIRA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-12371&JOSE_ANTONIO_REYES_RONCANC",
      num_rucom:"",
      rucom_record:"ARE_PLU-12371",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSE ANTONIO REYES RONCANCIO",
      status:"",
      mineral:"ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"RAQUIRA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-12371&JOSÉ_REINALDO_RONCANCIO_SI",
      num_rucom:"",
      rucom_record:"ARE_PLU-12371",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"JOSÉ REINALDO RONCANCIO SILVA",
      status:"",
      mineral:"ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"RAQUIRA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-12371&CARLOS_TORRES_MELO",
      num_rucom:"",
      rucom_record:"ARE_PLU-12371",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CARLOS TORRES MELO",
      status:"",
      mineral:"ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"RAQUIRA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-12231&COOPERATIVA_PRODUCTORA_DE_",
      num_rucom:"",
      rucom_record:"ARE_PLU-12231",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"COOPERATIVA PRODUCTORA DE CARBON DEL MUNICIPIO DE QUINCHIA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"QUINCHIA-RISARALDA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-11471&COOPROCA?ITAS",
      num_rucom:"",
      rucom_record:"ARE_PLT-11471",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"COOPROCA?ITAS",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"LA UVITA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-15121&GEOEXPLOTACIONES_S.A.S.",
      num_rucom:"",
      rucom_record:"ARE_PLT-15121",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"GEOEXPLOTACIONES S.A.S.",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SARDINATA-NORTE SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-13041&COOP._MULTIACTIVA_UNION_DE",
      num_rucom:"",
      rucom_record:"ARE_PLU-13041",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"COOP. MULTIACTIVA UNION DE MINEROS DE B/AIRES LTDA",
      status:"",
      mineral:"MINERALES DE ORO Y SUS CONCENTRADOS\\ MINERALES DE METALES PRECIOSOS Y SUS CONCENTRADOS",
      location:"SUAREZ-CAUCA\\ BUENOS AIRES-CAUCA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-15121&SOCIEDAD_DE_COMERCIALIZACI",
      num_rucom:"",
      rucom_record:"ARE_PLT-15121",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"SOCIEDAD DE COMERCIALIZACION INTERNACIONAL EXCOMIN SOCIEDAD POR ACCIONES SIMPLIFICADA-C.I. EXCOMIN S.A.S",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SARDINATA-NORTE SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-11301&ASOCIACION_COMUNITARIA_DE_",
      num_rucom:"",
      rucom_record:"ARE_PLU-11301",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ASOCIACION COMUNITARIA DE MINEROS DE CALIZA Y ARCILLA DE SAN JOSE DE MIRANDA ASOCAMIRA.",
      status:"",
      mineral:"CALIZA TRITURADA O MOLIDA\\ ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SAN JOSE DE MIRANDA-SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-09281&ASOCIACIÓN_DE_MINEROS_TRAD",
      num_rucom:"",
      rucom_record:"ARE_PLT-09281",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ASOCIACIÓN DE MINEROS TRADICIONALES ARTESANALES DE JERICÓ - BOYACÁ",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"JERICO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-10361&ASOCIACIÓN_DE_MINEROS_DEL_",
      num_rucom:"",
      rucom_record:"ARE_PLT-10361",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ASOCIACIÓN DE MINEROS DEL MORRO DE SOCOTÁ",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SOCOTA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-14421&ASOCIACIÓN_DE_ALFAREROS_DE",
      num_rucom:"",
      rucom_record:"ARE_PLT-14421",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ASOCIACIÓN DE ALFAREROS DE LA ZONA DE RESERVA ESPECIAL DE SOGAMOSO",
      status:"",
      mineral:"ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"SOGAMOSO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-15121&COOPERATIVA_MULTIACTIVA_DE",
      num_rucom:"",
      rucom_record:"ARE_PLT-15121",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"COOPERATIVA MULTIACTIVA DE PRODUCTORES DE CARBÓN DE LA ZONA DE RESERVA ESPECIAL",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SARDINATA-NORTE SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-16451&ASOCIACIÓN_DE_MINEROS_TRAD",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"ASOCIACIÓN DE MINEROS TRADICIONALES LA CARBONERA",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-16451&COMUNIDAD_MINERA_DE_LOS_SE",
      num_rucom:"",
      rucom_record:"ARE_PLT-16451",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"COMUNIDAD MINERA DE LOS SECTORES DE LA ZONA Y TIRRA EN LA VEREDA DE EL PEDREGAL",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"TASCO-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-13041&COOPERATIVA_DE_MINEROS_DE_",
      num_rucom:"",
      rucom_record:"ARE_PLU-13041",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"COOPERATIVA DE MINEROS DE SUÁREZ CAUCA",
      status:"",
      mineral:"MINERALES DE ORO Y SUS CONCENTRADOS\\ MINERALES DE METALES PRECIOSOS Y SUS CONCENTRADOS",
      location:"SUAREZ-CAUCA\\ BUENOS AIRES-CAUCA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLU-15261&CORPORACIÓN_DE_RESERVA_ESP",
      num_rucom:"",
      rucom_record:"ARE_PLU-15261",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"CORPORACIÓN DE RESERVA ESPECIAL MINERA PIRGUA NORTE TUNJA FABRICANTES DE MATERIALES PARA LA CONSTRUUCCIÓN \\\"CORESBOY\\\"",
      status:"",
      mineral:"ARCILLA COMUN (CERAMICAS, FERRUGINOSAS, MISCELANEAS)",
      location:"TUNJA-BOYACA",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"ARE_PLT-15121&BELLAVISTA_COAL_S.A.S.",
      num_rucom:"",
      rucom_record:"ARE_PLT-15121",
      provider_type:"Beneficiario Área Reserva Especial",
      name:"BELLAVISTA COAL S.A.S.",
      status:"",
      mineral:"CARBÓN MINERAL TRITURADO O MOLIDO",
      location:"SARDINATA-NORTE SANTANDER",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:28:24"
    },
    {
      idrucom:"RUCOM-20131220429",
      num_rucom:"RUCOM-20131220429",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"HORACIO VEGA CARDENAS",
      status:"Rechazado",
      mineral:"",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-20131220437",
      num_rucom:"RUCOM-20131220437",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"GESTION ENERGETICA S.A. ESP",
      status:"Rechazado",
      mineral:"",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-20131219297",
      num_rucom:"RUCOM-20131219297",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"GRUPO EMPRESARIAL SAN PABLO S.A.S.",
      status:"Certificado",
      mineral:"",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201401091846",
      num_rucom:"RUCOM-201401091846",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"CONSTRUCCIONES EL CONDOR S.A.",
      status:"En trámite, pendiente de evaluación",
      mineral:"",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201401292678",
      num_rucom:"RUCOM-201401292678",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"LUIS RICARDO GALINDO RIVERA",
      status:"Rechazado",
      mineral:"MATERIALES DE CONSTRUCCIÓN. GRAVILLA (MIG). GRAVAS NATURALES",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201402032742",
      num_rucom:"RUCOM-201402032742",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"HUMBERTO MORENO",
      status:"Rechazado",
      mineral:"GRAVAS NATURALES. MATERIALES DE CONSTRUCCIÓN. GRAVILLA (MIG)",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201401142182",
      num_rucom:"RUCOM-201401142182",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"ALEJANDRO GARCIA URRIAGO",
      status:"Certificado",
      mineral:"MINERALES DE ORO Y PLATINO, Y SUS CONCENTRADOS. DIAMANTES , INCLUSO LOS INDUSTRIALES, SIN LABRAR O SIMPLEMENTE ASERRADOS, HENDIDOS O DESBASTADOS Y OTRAS PIEDRAS PRECIOSAS Y SEMIPRECIOSAS SIN LABRAR O SIMPLEMENTE ASERRADAS O DESBASTADAS; PIEDRA PÓMEZ; ESMERIL; CORINDÓN NATURAL, GRANATE NATURAL Y OTROS ABRASIVOS NATURALES",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201503124821",
      num_rucom:"RUCOM-201503124821",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"PRODUCTOS LACTEOS AURA S.A.",
      status:"En trámite, pendiente de evaluación",
      mineral:"",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201402182869",
      num_rucom:"RUCOM-201402182869",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"Majolica Trading C.I. S.A.",
      status:"Rechazado",
      mineral:"MARMOL Y TRAVERTINO EN BRUTO. YESO (MIG). FUNDENTE DE ROCA O PIEDRA CALIZA; Y OTRAS PIEDRAS O ROCAS CALCAREAS DEL TIPO UTILIZADO HABITUALMENTE PARA LA FABRICACIÓN DE CAL O CEMENTO. OTRAS ROCAS O PIEDRAS TRITURADAS PARA CONSTRUCCIÓN NCP. BETUN Y ASFALTO NATURALES; ASFALTITAS Y ROCAS ASFALTICAS. ASFALTO NATURAL O ASFALTITAS. CAOLÍN CALCINADO O ELABORADO. CALCITA (MIG). CARBONATO DE BARIO NATURAL O WHITERITA. SAL MARINA SIN PURIFICAR. ABRASIVOS NATURALES. CUARZO O SÍLICE TRITURADO O MOLIDO. MAGNESIA CAUSTICA. LUTITAS Y ARENAS ALQUITRANÍFERAS (EXCEPTO ASFALTOS Y BETUNES NATURALES). MINERAL DE HIERRO SINTERIZADO. MINERALES DE ALUMINIO Y SUS CONCENTRADOS. MINERALES DE PLATINO Y SUS CONCENTRADOS. MINERALES DE ESTAÑO Y SUS CONCENTRADOS. MINERALES DE MOLIBDENO Y SUS CONCENTRADOS. PIZARRA EN BRUTO. PIZARRA (MIG). MARMOL Y TRAVERTINO EN BLOQUES. ROCA O PIEDRA CALIZA EN BRUTO. ROCA O PIEDRA CALIZA EN BLOQUES. GRAVAS NATURALES. ARENAS Y GRAVAS SILICEAS. ARENAS Y GRAVAS SILÍCEAS ELABORADAS (TRITURADAS, MOLIDAS O PULVERIZADAS). GRAVAS (EXCEPTO SILÍCEAS). MACADAN. LASCA. PIRITAS DE HIERRO SIN TOSTAR. DOLOMITA (CRUDA). ESMERALDAS SIN TALLAR. DIAMANTES , INCLUSO LOS INDUSTRIALES, SIN LABRAR O SIMPLEMENTE ASERRADOS, HENDIDOS O DESBASTADOS Y OTRAS PIEDRAS PRECIOSAS Y SEMIPRECIOSAS SIN LABRAR O SIMPLEMENTE ASERRADAS O DESBASTADAS; PIEDRA PÓMEZ; ESMERIL; CORINDÓN NATURAL, GRANATE NATURAL Y OTROS ABRASIVOS NATURALES. MINERALES PRECIOSOS NCP. MICA EN BRUTO O EN CRISTALES IRREGULARES. HULLA BITUMINOSA, ANTRACÍTICA, O CARBÓN MINERAL SIN AGLOMERAR. CARBÓN COQUIZABLE O METALURGICO. CARBÓN MINERAL TRITURADO O MOLIDO. MINERALES DE ORO Y PLATINO, Y SUS CONCENTRADOS. MINERALES DE METALES NO FERROSOS Y SUS CONCENTRADOS, NCP. PUZOLANA (MIG). ARENISCAS (MIG). LAS DEMAS ROCAS ASFALTICAS (EXCEPTO LAS DE LA SUBCLASE 12030). ROCA FOSFATICA O FOSFÓRICA, O FOSFORITA. OTROS MINERALES PARA LA EXTRACCIÓN DE PRODUCTOS QUÍMICOS. MINERALES DE BORO. PIEDRAS PRECIOSAS NCP SIN TALLAR. OTROS MINERALES NCP. ROCAS DE CUARCITA EN BRUTO O DESBASTADAS. TIERRA DE INFUSORIOS ELABORADA. MAGNESITA (O GIOBERTITA) DE CARBONATO DE MAGNESIO ÓXIDO DE MAGNESIO NATURAL. GRAFITO (MIG). MINERALES DE PLATA Y SUS CONCENTRADOS. MINERALES DE ORO Y SUS CONCENTRADOS. OTROS MINERALES DE METALES NO FERROSOS Y SUS CONCENTRADOS (EXCEPTO MINERALES Y CONCENTRADOS DE URANIO O TORIO). MINERALES DE CROMO Y SUS CONCENTRADOS. MINERALES DE NIOBIO, TANTALIO, VANADIO O CIRCONIO Y SUS CONCENTRADOS. CALIZA TRITURADA O MOLIDA. ROCA O PIEDRA CORALINA. ARENAS Y GRAVAS NATURALES Y SILICEAS. CONGLOMERADO (ROCA O PIEDRA). MINERALES DE POTASIO. CRETA, CALCITA Y DOLOMITA. SULFATO DE BARIO NATURAL-BARITINA. FLUORITA (MIG). MINERALES DE SODIO. PIEDRA PÓMEZ. GRANATE (MIG). CORINDON (MIG). CUARZO O SILICE. TIERRAS DIATOMACEAS SIN ACTIVAR. MICA EN POLVO. ESTEATITA O SILICATO DE MAGNESIO NATURAL HIDRATADO, EN BRUTO, INCLUSO PULVERIZADO. TURBA. MINERALES DE COBRE Y SUS CONCENTRADOS. OTROS MINERALES DE ALUMINIO Y SUS CONCENTRADOS NCP. MINERALES DE METALES PRECIOSOS Y SUS CONCENTRADOS. MINERALES DE PLOMO Y SUS CONCENTRADOS. MINERALES DE MANGANESO ( Y SUS CONCENTRADOS). CARBONATO NATURAL DE PLOMO - CERUCITA. MINERALES DE AZUFRE (EXCEPTO LAS PIRITAS). MINERALES DE ANTIMONIO Y SUS CONCENTRADOS. GRANITO (MIG). OTRAS ROCAS Y MINERALES DE ORIGEN VOLCANICO. FUNDENTE DE ROCA O PIEDRA CALIZA. MATERIALES DE CONSTRUCCIÓN. BENTONITA ELABORADA. OTRAS ARCILLAS NCP. FOSFATOS DE CALCIO NATURALES, FOSFATOS ALUMINOCALCICOS NATURALES Y CRETA FOSFATADA; CARNALITA, SILVINITA, OTRAS SALES NATURALES DE POTASIO SIN ELABORAR. DOLOMITA ELABORADA. BARITA ELABORADA. SALMUERA O SOLUCION SATURADA DE S",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201401292646",
      num_rucom:"RUCOM-201401292646",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"HECTOR MARIA REY ROMERO",
      status:"Rechazado",
      mineral:"GRAVILLA (MIG). GRAVAS NATURALES. MATERIALES DE CONSTRUCCIÓN",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201402032769",
      num_rucom:"RUCOM-201402032769",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"EDGAR GARCIA MAYORGA",
      status:"Rechazado",
      mineral:"GRAVILLA (MIG). MATERIALES DE CONSTRUCCIÓN. GRAVAS NATURALES",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201405233283",
      num_rucom:"RUCOM-201405233283",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"Juan Carlos Gomez Castaño",
      status:"En trámite, pendiente de evaluación",
      mineral:"MATERIALES DE CONSTRUCCIÓN. MINERALES DE ORO Y PLATINO, Y SUS CONCENTRADOS. BARITA ELABORADA. MAGNESITA (O GIOBERTITA) DE CARBONATO DE MAGNESIO ÓXIDO DE MAGNESIO NATURAL. FUNDENTE DE ROCA O PIEDRA CALIZA; Y OTRAS PIEDRAS O ROCAS CALCAREAS DEL TIPO UTILIZADO HABITUALMENTE PARA LA FABRICACIÓN DE CAL O CEMENTO. OTROS MINERALES PARA LA EXTRACCIÓN DE PRODUCTOS QUÍMICOS. MINERALES DE ORO Y SUS CONCENTRADOS. ROCA O PIEDRA CALIZA EN BRUTO. YESO NATURAL; ANHIDRITA",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201405263300",
      num_rucom:"RUCOM-201405263300",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"FELIBERTA CAICEDO BANGUERA",
      status:"Rechazado",
      mineral:"MINERALES DE PLATA Y SUS CONCENTRADOS. MINERALES DE ORO Y PLATINO, Y SUS CONCENTRADOS. MINERALES DE PLATINO Y SUS CONCENTRADOS. MINERALES DE METALES PRECIOSOS Y SUS CONCENTRADOS. MINERALES DE ORO Y SUS CONCENTRADOS",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201404023137",
      num_rucom:"RUCOM-201404023137",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"LATIN ENGINEERING S.A.S",
      status:"Rechazado",
      mineral:"FUNDENTE DE ROCA O PIEDRA CALIZA. ARENAS ARCILLOSAS. ARENAS Y GRAVAS SILÍCEAS ELABORADAS (TRITURADAS, MOLIDAS O PULVERIZADAS). ARENAS INDUSTRIALES (MIG). CONGLOMERADOS, ARENISCAS, CANTOS, GRAVAS, MACADAN; MACADAN ALQUITRANADO; GRAVILLA, LASCA Y POLVOS DE ROCA O PIEDRA, INCLUSO LOS DE LAS PIEDRAS DE LAS CLASES 1512 Y 1513 (EXCEPTO LOS DE LA SUBCLASE 37690), Y DEMAS ROCAS TRITURADAS O NO PARA CONSTRUCCIÓN . ASFALTO NATURAL O ASFALTITAS. ROCA O PIEDRA CALIZA EN BRUTO. CARBON TERMICO. ARENAS FELDESPATICAS. LAS DEMAS ROCAS ASFALTICAS (EXCEPTO LAS DE LA SUBCLASE 12030). CARBÓN COQUIZABLE O METALURGICO. CALIZA TRITURADA O MOLIDA. CARBÓN MINERAL TRITURADO O MOLIDO. FUNDENTE DE ROCA O PIEDRA CALIZA; Y OTRAS PIEDRAS O ROCAS CALCAREAS DEL TIPO UTILIZADO HABITUALMENTE PARA LA FABRICACIÓN DE CAL O CEMENTO. CONGLOMERADO (ROCA O PIEDRA). ARENAS Y GRAVAS NATURALES Y SILICEAS. RECEBO (MIG). MATERIALES DE CONSTRUCCIÓN. GRAVAS (EXCEPTO SILÍCEAS). OTRAS ROCAS O PIEDRAS TRITURADAS PARA CONSTRUCCIÓN NCP. BETUN Y ASFALTO NATURALES; ASFALTITAS Y ROCAS ASFALTICAS. GRAVAS NATURALES. ARENAS Y GRAVAS SILICEAS. GRAVILLA (MIG). TIERRAS INDUSTRIALES",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201403143055",
      num_rucom:"RUCOM-201403143055",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"Julian Cuartas Restrepo",
      status:"Certificado",
      mineral:"MINERALES DE PLATA Y SUS CONCENTRADOS. MINERALES DE ORO Y SUS CONCENTRADOS. MINERALES PRECIOSOS NCP. MINERALES DE METALES PRECIOSOS Y SUS CONCENTRADOS. PIEDRAS PRECIOSAS NCP SIN TALLAR",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201502024465",
      num_rucom:"RUCOM-201502024465",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"ROSA PATRICIA GOMEZ SANCHEZ",
      status:"En trámite, pendiente de evaluación",
      mineral:"MINERALES DE ORO Y PLATINO, Y SUS CONCENTRADOS. PIEDRAS SEMIPRECIOSAS NCP SIN TALLAR. ESMERALDAS EN BRUTO, SIN LABRAR O SIMPLEMENTE ASERRADAS O DESBASTADAS. MINERALES PRECIOSOS NCP. DIAMANTES INDUSTRIALES, SIN LABRAR O SIMPLEMENTE ASERRADOS, HENDIDOS O DESBASTADOS",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201503114812",
      num_rucom:"RUCOM-201503114812",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"MAVI PAVIMENTACIONES S.A.S.",
      status:"En trámite, pendiente de evaluación",
      mineral:"MATERIALES DE CONSTRUCCIÓN. GRAVILLA (MIG). MACADAN ALQUITRANADO. ROCA O PIEDRA CALIZA EN BRUTO. GRAVAS (EXCEPTO SILÍCEAS). LAS DEMAS ROCAS ASFALTICAS (EXCEPTO LAS DE LA SUBCLASE 12030). CONGLOMERADOS, ARENISCAS, CANTOS, GRAVAS, MACADAN; MACADAN ALQUITRANADO; GRAVILLA, LASCA Y POLVOS DE ROCA O PIEDRA, INCLUSO LOS DE LAS PIEDRAS DE LAS CLASES 1512 Y 1513 (EXCEPTO LOS DE LA SUBCLASE 37690), Y DEMAS ROCAS TRITURADAS O NO PARA CONSTRUCCIÓN . MACADAN. ASFALTO NATURAL O ASFALTITAS. ROCAS O PIEDRAS CALIZAS DE TALLA O DE CONSTRUCCIÓN NCP. ARENAS Y GRAVAS SILICEAS. ARENAS INDUSTRIALES (MIG). ROCA O PIEDRA CALIZA EN BLOQUES. OTRAS ROCAS METAMÓRFICAS PARA CONSTRUCCIÓN Y TALLA NCP. ROCAS DE ORIGEN VOLCANICO. ARENAS Y GRAVAS SILÍCEAS ELABORADAS (TRITURADAS, MOLIDAS O PULVERIZADAS). TRITURADO DE MARMOL EN ESTADO NATURAL. OTRAS ROCAS O PIEDRAS TRITURADAS PARA CONSTRUCCIÓN NCP",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201502104541",
      num_rucom:"RUCOM-201502104541",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"FRANCISCO JAVIER GIRALDO ORTIZ",
      status:"En trámite, pendiente de evaluación",
      mineral:"MINERALES DE ORO Y SUS CONCENTRADOS",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    },
    {
      idrucom:"RUCOM-201502244680",
      num_rucom:"RUCOM-201502244680",
      rucom_record:"",
      provider_type:"Consumidor",
      name:"O - TEK INTERNACIONAL S.A.",
      status:"En trámite, pendiente de evaluación",
      mineral:"ARENAS Y GRAVAS SILÍCEAS ELABORADAS (TRITURADAS, MOLIDAS O PULVERIZADAS). ARENAS FELDESPATICAS. ARENAS INDUSTRIALES (MIG). ARENAS Y GRAVAS NATURALES Y SILICEAS. ARENAS ARCILLOSAS",
      location:"",
      subcontract_number:"",
      mining_permit:"",
      updated_at:"2015-03-31 16:30:31"
    }
  ]

  #
  #  rucom
  #

  # GET
  # endpoint for retrieving rucom registries by num_rucom, rucom_record or subcontract_number
  app.get '/api/v1/rucoms?', (req, res) ->
    console.log 'retrieving rucom registries matching ' + req.query.rucom_attr + ' from the fake server ...'
    rucoms = []
    for r of rucoms_reg
      if rucoms_reg[r].num_rucom == req.query.rucom_attr or rucoms_reg[r].rucom_record == req.query.rucom_attr or rucoms_reg[r].subcontract_number == req.query.rucom_attr
        rucoms.push rucoms_reg[r]
    res.json {
      result: rucoms,
      access_token: 'super_save_token'
    }
  
  # GET
  # endpoint for retrieving providers by ID
  app.get '/api/v1/rucoms/:rucomId', (req, res) ->
    console.log 'retrieving rucom ' + req.params.rucomId + ' from the fake server ...'
    rucom = {}
    for r of rucoms_reg
      if rucoms_reg[r].idrucom == req.params.rucomId
        rucom = rucoms_reg[r]
        break
    res.json {
      rucom: rucom,
      access_token: 'super_save_token'
    }