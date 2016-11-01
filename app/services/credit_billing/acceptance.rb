class CreditBilling::Acceptance
  attr_accessor :credits_buyer
  attr_accessor :credit_billing
  attr_accessor :response

  def initialize
    @response = {}
    @response[:success] = false
    @response[:errors] = []
  end

  def call(options={})
    raise 'You must to provide credit_billing option' if options[:credit_billing].blank?
    raise 'You must to provide new_credit_billing_values option' if options[:new_credit_billing_values].blank?
    @credit_billing = options[:credit_billing]
    new_credit_billing_values = options[:new_credit_billing_values]
    @credits_buyer = credits_buyer_from(credit_billing)
    @response[:success] = current_available_credits = credits_buyer.available_credits
    @response
    ActiveRecord::Base.transaction do
      update_credit_billings_with!(new_credit_billing_values)
      update_credits_buyer_with(current_available_credits, credit_billing.quantity) if credit_billing.reload.paid?
      service = Alegra::Credits::UpdateInvoice.new
      @response = service.call(credit_billing: credit_billing)
    end
    rescue Exception => e
      @response[:errors] << e.message
      @response
  end

  # @return [ User ]
  def credits_buyer_from(credit_billing)
    if credit_billing.user.has_office?
      credit_billing.user.office.company.legal_representative
    else
      credit_billing.user
    end
  end

  # @return [ Boolean ]
  def update_credit_billings_with!(new_values)
    credit_billing.update(new_values)
  end

  # @return [ Boolean ]
  def update_credits_buyer_with(current_available_credits, credits_to_add)
    new_credit_amount = current_available_credits + credits_to_add
    credits_buyer.profile.update_attributes(available_credits: new_credit_amount)
  end
end