class ProofOfSalePresenter < BasePresenter
  presents :sale

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
    UserPresenter.new(buyer, h)
  end

  def seller_presenter
    UserPresenter.new(user, h)
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

  def grams
    fine_grams # TODO: check what this field means in the equivalent document
  end

  def fine_gram_price
    "$#{ (price/gold_batch.fine_grams).round(2) }"
  end

  def total_price
    "$#{ price.round(2) }"
  end
end