class CreditBilling::Acceptance
  attr_accessor :credits_buyer
  attr_accessor :credit_billing

  def intialize
  end

  def call(options={})
    raise 'You must to provide credit_billing option' if options[:credit_billing].blank?
    raise 'You must to provide new_credit_billing_values option' if options[:new_credit_billing_values].blank?
    response = {}
    @credit_billing = options[:credit_billing]
    new_credit_billing_values = options[:new_credit_billing_values]
    @credits_buyer = credits_buyer_from(credit_billing)
    current_available_credits = credits_buyer.available_credits

    ActiveRecord::Base.transaction do
      response = update_credit_billings_with!(new_credit_billing_values)
      response = update_credits_buyer_with(current_available_credits, credit_billing.unit) if response[:success]
    end
    response
  end

  def credits_buyer_from(credit_billing)
    if credit_billing.user.has_office?
      credit_billing.user.office.company.legal_representative
    else
      credit_billing.user
    end
  end

  def update_credit_billings_with!(new_values)
    {
      success: credit_billing.update(new_values),
      errors: credits_buyer.errors.full_messages
    }
  end

  def update_credits_buyer_with(current_available_credits, credits_to_add)
    new_credit_amount = current_available_credits + credits_to_add
    {
      success: credits_buyer.update_attributes(available_credits: new_credit_amount),
      errors: credits_buyer.errors.full_messages
    }
  end
end