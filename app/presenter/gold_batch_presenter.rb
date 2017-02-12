class GoldBatchPresenter < BasePresenter
  presents :gold_batch

  # These are the measurements used to calculated the fine_grams field

  def rounded_castellanos
    castellanos.round(3).to_s if castellanos?
  end

  def rounded_tomines
    tomines.round(3).to_s if tomines?
  end

  def rounded_onzas
    onzas.round(3).to_s if onzas?
  end

  def rounded_grams
    "#{grams.round(3)}" if grams?
  end

  def rounded_reales
    reales.round(3).to_s if reales?
  end

  def rounded_granos
    granos.round(3).to_s if granos?
  end

  def origin_certificate_number
    'NA'
  end

  def total_fine_grams
    fine_grams.present? ? "#{ fine_grams.round(3) } Gramos" : raise('fine grams cannot be blank!!')
  end

  def formatted_fine_grams
    fine_grams.present? ? fine_grams.round(3) : raise('fine grams cannot be blank!!')
  end

  def seller_presenter
    UserPresenter.new(goldomable.seller, h)
  end
end
