class GoldBatchPresenter < BasePresenter
  presents :gold_batch

  # These are the measurements used to calculated the fine_grams field

  def rounded_castellanos
    castellanos.round(2).to_s if castellanos?
  end

  def rounded_tomines
    tomines.round(1).to_s if tomines?
  end

  def rounded_onzas
    onzas.round(2).to_s if onzas?
  end

  def rounded_grams
    "#{grams.round(2)} grams" if grams?
  end

  def rounded_reales
    reales.round(2).to_s if reales?
  end

  def rounded_granos
    granos.round(2).to_s if granos?
  end

  def origin_certificate_number
    'NA'
  end

  def total_fine_grams
    fine_grams.present? ? "#{ fine_grams.round(2) } grams" : raise('fine grams cannot be blank!!')
  end

  def formatted_fine_grams
    fine_grams.present? ? fine_grams.to_s : raise('fine grams cannot be blank!!')
  end

  def seller_presenter
    UserPresenter.new(goldomable.seller, h)
  end
end