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


  #
  #  provider
  #

  # GET
  # it is a possible route for the provider (it is inventory or inventories ?)
  app.get '/api/v1/provider', (req, res) ->
    list = [
              {
                thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png', 
                name: 'Diego Caicedo',
                id: '9800000-1',
                mineral: 'Oro',
                id_rucom: 'RUCOM-201502204885',
                rucom_status: 'En trámite, pendiente de evaluación',
                last_transaction_date: '1427226977293',
                prov_type: 2,
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
                id_rucom: 'RUCOM-201503014886',
                rucom_status: 'Certificado',
                last_transaction_date: '1427226977300',
                prov_type: 3,
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
                id_rucom: 'RUCOM-201403014887',
                rucom_status: 'Certificado',
                last_transaction_date: '1427226978293',
                prov_type: 4,
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
                id_rucom: 'RUCOM-201303014890',
                rucom_status: 'En trámite, pendiente de evaluación',
                last_transaction_date: '1427226977493',
                prov_type: 5,
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
                id_rucom: 'RUCOM-201503014892',
                rucom_status: 'En trámite, pendiente de evaluación',
                last_transaction_date: '1427226977600',
                prov_type: 6,
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
                id_rucom: 'RUCOM-201203014810',
                rucom_status: 'Certificado',
                last_transaction_date: '1427226977550',
                prov_type: 7,
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
                id_rucom: 'RUCOM-201303014800',
                rucom_status: 'En trámite, pendiente de evaluación',
                last_transaction_date: '1427226978293',
                prov_type: 1,
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
                id_rucom: 'RUCOM-201403014802',
                rucom_status: 'Certificado',
                last_transaction_date: '1427226977893',
                prov_type: 2,
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
                id_rucom: 'RUCOM-201303014201',
                rucom_status: 'Certificado',
                last_transaction_date: '1427226979293',
                prov_type: 3,
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
                id_rucom: 'RUCOM-201403014833',
                rucom_status: 'Certificado',
                last_transaction_date: '1427226977777',
                prov_type: 4,
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
                id_rucom: 'RUCOM-201403014943',
                rucom_status: 'Certificado',
                last_transaction_date: '1427227113631',
                prov_type: 5,
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
                id_rucom: 'RUCOM-201503204884',
                rucom_status: 'En trámite, pendiente de evaluación',
                last_transaction_date: '1427227123631',
                prov_type: 6,
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
                id_rucom: 'RUCOM-201503204883',
                rucom_status: 'En trámite, pendiente de evaluación',
                last_transaction_date: '1427227133631',
                prov_type: 7,
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
                id_rucom: 'RUCOM-201503194882',
                rucom_status: 'En trámite, pendiente de evaluación',
                last_transaction_date: '1427227113731',
                prov_type: 1,
                type: 'Persona Natural',
                phone_nb: '314 757 9454',
                address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
                email: 'sandis.martinez@gmail.com',
                city: 'Popayán',
                state: 'CAUCA',
                postalCode : '94043'
              }
    ];
    console.log 'provider list from the fake server ...'

    res.json {
      list: list,
      access_token: 'super_save_token'
    }
