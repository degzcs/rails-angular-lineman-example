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
    res.json {
      name: 'Pepito',
      document_number: '123456789',
      phone: '+57300214587',
      address: 'calle falsa # 12 -3',
      email: 'pepito@fake.com',
      access_token: 'super_save_token'
    }

