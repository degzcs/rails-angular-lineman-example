class GeneratePdfWorker
  include Sidekiq::Worker

  SERVICE_NAMES = %w(Generation GenerationWatermark).freeze

  def perform(order_id, service_name='GenerationWatermark' )
    order = ::Order.find(order_id)
    message = "Error, Servicio no conocido => ::Sale::PurchaseFilesCollection::#{service_name}, valores permitidos: #{SERVICE_NAMES.inspect}"
    raise message unless SERVICE_NAMES.include? service_name.camelize
    #Allows to load the carrierwave setup 
    require "#{Rails.root}/config/initializers/carrierwave"
    "::Sale::PurchaseFilesCollection::#{service_name.camelize}".constantize.new.call(sale_order: order)
  end
end