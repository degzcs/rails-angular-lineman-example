module StateMachines
  module OrderStates
    STATES = {
      initialized: 'Inicializado',
      failed:  'Error',
      dispached: 'Enviado',
      approved: 'Aprobado',
      canceled: 'Rechazado',
      paid: 'Pagado'
    }

    def self.included(base)
      base.send 'before_save', :persist_status
      base.extend(ClassMethods)
    end

    def status_label
      transaction_state && STATES[transaction_state.to_sym]
    end

    def initialized?
      (transaction_state || status.state) == 'initialized'
    end

    def approved?
      transaction_state == 'approved'
    end

    def not_approved?
      transaction_state == 'canceled'
    end

    def failed?
      transaction_state == 'failed'
    end

    def dispatched?
      transaction_state == 'dispatched'
    end

    def paid?
      transaction_state == 'paid'
    end

    def end_transaction!
      if self.type == 'purchase'
        status.trigger!(:end_purchase) if initialized?
      elsif approved? || failed?
        status.trigger!(:end_sale)
        self.save!
      end
    end

    def crash!
      status.trigger(:crash)
      self.save!
    end

    def agree!
      return unless self.type == 'sale' # TODO: it should be a different condition more like: self.buyer == current_buyer
      status.trigger!(:agree)
      self.save!
      callbacks(status)
    end

    def send_info!
      return unless self.type == 'sale'
      status.trigger!(:send_info)
      self.save!
      callbacks(status)
    end

    def cancel!
      return unless self.type == 'sale'
      status.trigger!(:cancel)
      self.save!
      callbacks(status)
    end

    # 
    # state => String = With the current state name of the state machine
    # emails => Array = With email strings
    # return => Array = With inside a hash for each email sent like this :
    # [
    #   {
    #           "email" => "pcarmonaz@gmail.com",
    #          "status" => "sent",
    #             "_id" => "d8ff38c5f5404cdf9090668e4a5344bb",
    #   "reject_reason" => nil
    #   }
    # ]
    def send_mandrill_email(state, emails=[], merge_vars={}, attachments=[], options={})
      TrazoroMandrill::Service.send_email(template_name(state), 'Buy Order ' + state, merge_vars, emails, options, attachments)
    end

    def template_name(state)
      "#{self.class.name.downcase}_#{state}_template"
    end

    def status
      @status ||= begin
                    fsm = MicroMachine.new(transaction_state || "initialized")
                    # purchases transaction states
                    fsm.when(:end_purchase, 'initialized' => 'paid', 'failed' => 'paid')

                    # sales transaction states
                    fsm.when(:send_info, 'initialized' => 'dispatched', 'failed' => 'dispatched')
                    fsm.when(:agree, 'dispatched' => 'approved', 'failed' => 'approved')
                    fsm.when(:cancel, 'dispatched' => 'canceled', 'failed' => 'canceled')
                    fsm.when(:end_sale, 'approved' => 'paid', 'failed' => 'paid')
                    fsm.when(:crash, 'initialized' => 'failed', 'dispatched' => 'failed', "approved" => "failed", "canceled" => "failed")

                    fsm
                  end
    end

    def callbacks(machine)
      return unless self.type == 'sale'
      state = machine.state
      response = {}

      case state
      when 'dispatched'
          self.response = send_mandrill_email(state, [self.buyer.email], {NAME: :name}, [self.proof_of_sale])

      when 'approved'
        response = ::Sale::PurchaseFilesCollection::Generation.new.call(sale_order: self)
        response = send_mandrill_email(state, [self.seller.email], {NAME: :name, COMPANY_NAME: :company_name}, [self.proof_of_sale])
        service = Alegra::Traders::CreateInvoice.new
        response = service.call(order: self, payment_method: 'transfer', payment_date: Time.now )

      when 'canceled'
          response  = send_mandrill_email(state, [self.buyer.email])

      else
        # Don't do anything!
      end
      response
    rescue Exception => error
      response[:error] = error
      response
    end

    module ClassMethods
      def states_for_select
        STATES.collect { |val| [val[1], val[0]] }
      end
    end

    private

    def persist_status
      self.transaction_state = status.state
    end
  end
end
