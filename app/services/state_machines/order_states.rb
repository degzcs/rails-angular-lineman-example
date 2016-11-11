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
      else
        status.trigger!(:end_sale) if approved?
      end
    end

    def crash!
      status.trigger(:crash)
    end

    def agree!
      if self.type == 'sale' # TODO: it should be a different condition more like: self.buyer == current_buyer
        status.trigger!(:agree)
        save!
      end
    end

    def send_info!
      if self.type == 'sale'
        status.trigger!(:send_info)
        #res = send_mandrill_email(status.state)
      end
    end

    def cancel!
      status.trigger!(:cancel) if self.type == 'sale'
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
    def send_mandrill_email(state, emails=[])
      TrazoroMandrill::Service.send_email!(template_name(state), 'Buy Order Pending to Approved', {}, emails)
    end

    def template_name(state)
      "#{self.class.name.lower}_#{state}_template"
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

                    callbacks(fsm)
                    
                    fsm.on(:dispatched) do
                      send_mandrill_email('dispatched', [self.buyer.email])
                    end

                    fsm.on(:approved) do
                      send_mandrill_email('dispatched', [self.buyer.email]) if self.type == 'sale'
                    end

                    fsm.on(:canceled) do
                      send_mandrill_email('dispatched', [self.buyer.email]) if self.type == 'sale'
                    end

                    fsm
                  end
    end

    def callbacks(machine)
      machine.on('approved') do
        service = Alegra::Traders::CreateInvoice.new
        service.call(order: self, payment_method: 'transfer', payment_date: Time.now )
      end
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
