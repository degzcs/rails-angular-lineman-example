class OrderPresenter < BasePresenter
  presents :order

  def date
    created_at.to_time.getlocal('-05:00')
  end

  def hms_time
    date.strftime("%H:%M:%S")
  end

  def ymd_time
    date.strftime("%Y/%m/%d")
  end

  def buyer_presenter
    @buyer_presenter ||= UserPresenter.new(buyer, h)
  end

  def seller_presenter
    @seller_presenter ||= UserPresenter.new(seller, h)
  end

  def gold_batch_presenter
    @gold_batch_presenter ||= GoldBatchPresenter.new(gold_batch, h)
  end

  # NOTE: This is a different kind of user but he/she will be in user table some day, at that time
  # We should to use UserPresenter class instead CourierPresenter class.
  def courier_presenter
    CourierPresenter.new(courier, h)
  end

  def gold_batch_presenters
    batches.map do |sold_batch|
      GoldBatchPresenter.new(sold_batch.gold_batch, h)
    end
  end

  # NOTE: The trazoro transaction cost will be implemented in a model CreditBilling (ServiceBilling) and not in the presenter
  def settings_presenter
    SettingsPresenter.new(Settings.instance, h)
  end

  def iva
    settings_presenter.vat_percentage.to_f/100
  end

  def trazoro_fine_gram_value
    settings_presenter.fine_gram_value.to_f
  end

  def trazoro_transaction_cost_value
    (gold_batch.fine_grams.to_f * settings_presenter.fine_gram_value.to_f).round(2)
  end

  # Costo trazoro = gramo fino * precio trazoro
  def trazoro_transaction_cost
    trazoro_transaction_cost_value.round(2)
  end

  # IVA
  def trazoro_transaction_vat
    (trazoro_transaction_cost_value.to_f * iva).round(2)
  end

  # C. trazoro total = Costo trazoro + IVA
  def trazoro_transaction_total_cost
    "$#{ (trazoro_transaction_cost.to_f + trazoro_transaction_vat.to_f).round(2) }"
  end

  def grams
    fine_grams # TODO: check what this field means in the equivalent document
  end

  def fine_gram_price
    "$#{ (price/gold_batch.fine_grams).round(2) }"
  end

  # presenter of sold's state
  def state
    gold_batch.sold? ? 'Vendido' : 'Disponible'
  end

  def total_price
    (price).round(2)
  end

  def real_gold_cost
    total_price - (trazoro_transaction_cost_value + trazoro_transaction_vat)
  end

  def sale_sequence_format
    sprintf '%05d', transaction_sequence.to_i
  end

  def total_fine_grams
    fine_grams.present? ? "#{ fine_grams.round(3) } Gramos" : raise('fine grams cannot be blank!!')
  end

  def currency_format(number)
    ApplicationController.helpers.number_to_currency(number, precision: 0, unit: 'COP$', delimiter: '.')
  end
end
