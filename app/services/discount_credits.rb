class DiscountCredits
  attr_accessor :response
  attr_accessor :buyed_fine_grams
  attr_accessor :buyer

  def initialize
    @response = {}
    @response[:errors] = []
    @response[:success] = false
  end

  def call(options = {})
    raise 'You must to provide a buyer' if options[:buyer].blank?
    raise 'You must to provide a buyed_fine_grams' if options[:buyed_fine_grams].blank?
    options.deep_symbolize_keys!
    @buyed_fine_grams = options[:buyed_fine_grams]
    @buyer = options[:buyer]
    if can_buy?
      services = buyer.setting.trazoro_services
      calculate_amount_to_discount_based_on_service(buyer, services, buyed_fine_grams)
      response[:success] = true
    end
    response
  end

  def can_buy?
    check_it_user_enough_credits?(buyer, buyed_fine_grams) &&
      check_that_the_user_has_available_services?(buyer)
  end

  def check_it_user_enough_credits?(buyer, buyed_fine_grams)
    if buyer.profile.available_credits >= buyed_fine_grams.to_f
      true
    else
      raise 'No tienes los suficientes creditos para hacer esta compra'
    end
  end

  def check_that_the_user_has_available_services?(buyer)
    if buyer.setting.trazoro_services.present?
      true
    else
      raise 'No cuentas con servicios trazoro'
    end
  end

  def calculate_amount_to_discount_based_on_service(buyer, services, buyed_fine_grams)
    service_buy_gold = services.find_by(reference: 'buy_gold')
    if service_buy_gold.present?
      res = buyed_fine_grams.to_f * service_buy_gold.credits
      new_credits = buyer.available_credits - res
      buyer.profile.update_column(:available_credits, new_credits)
      buyer
    else
      raise 'Usted no cuenta con el servicio de compra de oro trazoro'
    end
  end
end
