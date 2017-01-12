class GeneratePdfWorker
  include Sidekiq::Worker

  def perform(order_id, service_name='' )
    order = Order.find(order_id)
    response = ::Sale::PurchaseFilesCollection::GenerationWatermark.new.call(sale_order: order)
  end
end