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
    UserPresenter.new(client, h)
  end

  def seller_presenter
    UserPresenter.new(user, h)
  end

  def courier_presenter
    UserPresenter.new(courier, h)
  end

  def gold_batch_presenters
    gold_batches.map do |gold_batch|
      GoldBatchPresenter.new(gold_batch, h)
    end
  end

  def fine_gram_price
    "$#{ (price/gold_batch.fine_grams).round(2) }"
  end

  def total_price
    "$#{ price.round(2) }"
  end
end