class GoldBatchPresenter < BasePresenter
  presents :gold_batch

  # These are the measurements used to calculated the fine_grams field

  def rounded_castellanos
    castellanos.round(2) if castellanos?
  end

  def rounded_tomines
    tomines.round(1) if tomines?
  end

  def rounded_onzas
    onzas.round(2) if onzas?
  end

  def rounded_grams
    "#{grams.round(2)} grams" if grams?
  end

  def rounded_reales
    reales.round(2) if reales?
  end

  def origin_certificate_number
    'Pending...'
  end

  def total_fine_grams
    "#{ fine_grams.round(2) } grams" if fine_grams.present?
  end

  def formatted_fine_grams
    fine_grams.to_s
  end

  def seller_presenter
    UserPresenter.new(goldomable.inventory.user, h)
  end
end