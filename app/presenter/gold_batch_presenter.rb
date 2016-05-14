class GoldBatchPresenter < BasePresenter
  presents :gold_batch

  # These are the measurements used to calculated the fine_grams field

  def rounded_castellanos
    castellanos.round(2)
  end

  def rounded_tomines
    tomines.round(1)
  end

  def rounded_onzas
    onzas.round(2)
  end

  def rounded_grams
    "#{grams.round(2)} grams"
  end

  def rounded_reales
    reales.round(2)
  end

  def total_fine_grams
    "#{fine_grams.round(2)} grams"
  end
end