class ProofOfPurchasePresenter < BasePresenter
  presents :purchase

  def date
    created_at.to_time.getlocal('-05:00')
  end

  def hms_time
    date.strftime("%H:%M:%S")
  end

  def buyer
    @buyer ||= UserPresenter.new(user, h)
  end

  def provider
    @provider ||= UserPresenter.new(user, h)
  end

  def gold_batch
    @gold_batch = GoldBatchPresenter.new(gold_batch, h)
  end

  def fine_gram_price
    "$#{ (price/gold_batch.fine_grams).round(2) }"
  end

  def total_price
    "$#{ price.round(2) }"
  end
end