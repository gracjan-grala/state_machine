module StateMachine
  module ClassDefinition
    attr_reader :states, :initial

    def state(state_name, options = {})
      if options[:initial]
        if @initial
          raise Error::InitialStateAlreadyDefined, 'Initial state has already been defined'
        end
        @initial = state_name
      end

      @states[state_name] = State.new(state_name)
      define_method "#{state_name}?" do
        current_state == state_name.to_sym
      end
    end

    def event(event_name)
      transitions = yield

      define_method "can_#{event_name}?" do
        true
      end

      define_method "#{event_name}!" do
        self.current_state = transitions[:to]
      end
    end

    def transitions(from:, to:)
      validate_states(from, to)

      { from: Helpers.coerce_array(from).map(&:to_sym), to: to.to_sym }
    end

    def validate_states(*states)
      states.flatten.each do |state|
        unless @states.key?(state)
          raise Error::UndefinedState, "State #{@state} has not been defined"
        end
      end
    end
  end
end
