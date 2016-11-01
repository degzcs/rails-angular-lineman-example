module StateMachines
  module UserStates
    STATES = {
      initialized: 'insertado desde rucom',
      completed: 'Completado',
      failure: 'Error'
      # paused: ''
    }

    def self.included(base)
      base.send 'before_save', :persist_status
      base.extend(ClassMethods)
    end

    def status_label
      registration_state && STATES[registration_state.to_sym]
    end

    def initialized?
      (registration_state || status.state) == 'initialized'
    end

    def completed?
      registration_state == 'completed'
    end

    def failure?
      registration_state == 'failure'
    end

    def crash!
      status.trigger(:crash)
    end

    def complete!
      status.trigger!(:complete)
    end

    def status
      @status ||= begin
                    mcm = MicroMachine.new(registration_state || 'initialized')
                    mcm.when(:crash, 'initialized' => 'failure')
                    mcm.when(:complete, 'initialized' => 'completed')
                    #
                    # Callbacks
                    #
                    mcm.on('completed') do
                      syncronize_with_alegra!(APP_CONFIG[:ALEGRA_SYNC])
                    end
                    mcm
                  end
    end

    module ClassMethods
      def states_for_select
        STATES.collect { |val| [val[1], val[0]] }
      end
    end

    private

    def persist_status
      self.registration_state = status.state
    end
  end
end
