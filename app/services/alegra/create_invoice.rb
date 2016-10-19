module Alegra
  class CreateInvoice
    def initialize(options={})
    end

    def call(options={})
      # Find client by name or id or whatever
      # I think I should create this user (trader) when their register is completed,
      # this way I will able to call this user by their id and send this value
      # into the invoice#create paramters.

      # Migrate a new field into user model which will save the alegra id (I gonna named alegra_id).

      # Generate the inovoice calling  the Algra::Invoices#create method.
    end
  end
end
