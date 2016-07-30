module StateMachine
  module ClassDefinition
    attr_reader :states, :initial, :events

    private

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
      @events[event_name.to_sym] = transitions
      destination_state = transitions.to

      define_method "can_#{event_name}?" do
        self.class.events[event_name.to_sym].transition?(from: current_state, to: destination_state)
      end

      define_method "#{event_name}!" do
        unless send("can_#{event_name}?")
          raise Error::IllegalTransition,
                "Event #{event_name} doesn't allow transition
                from #{current_state} to #{destination_state}"
        end
        self.current_state = destination_state
      end
    end

    def transitions(from:, to:)
      validate_states(from, to)

      Event.new(from: from, to: to)
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
