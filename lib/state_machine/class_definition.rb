module StateMachine
  module ClassDefinition
    attr_reader :states, :initial, :events

    private

    def state(state_name, options = {})
      if options[:initial]
        if @initial
          raise Errors::InitialStateAlreadyDefined, 'Initial state has already been defined'
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
        self.class.events[event_name.to_sym]
          .transition?(from: current_state, to: destination_state, caller: self)
      end

      define_method "#{event_name}!" do
        unless send("can_#{event_name}?")
          raise Errors::IllegalTransition,
                "Event #{event_name} doesn't allow transition
                from #{current_state} to #{destination_state}"
        end
        self.current_state = destination_state
      end
    end

    def transitions(options)
      validate_states(options[:from], options[:to])

      Event.new(from: options[:from], to: options[:to], guard: options[:when])
    end

    def validate_states(*states)
      states.flatten.each do |state|
        unless @states.key?(state)
          raise Errors::UndefinedState, "State #{@state} has not been defined"
        end
      end
    end
  end
end
