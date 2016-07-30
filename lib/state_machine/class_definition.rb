module StateMachine
  module ClassDefinition
    attr_reader :states, :initial, :events, :before_callbacks, :after_callbacks

    private

    def state(state_name, options = {})
      if options[:initial]
        if @initial
          raise Errors::InitialStateAlreadyDefined, 'Initial state has already been defined'
        end
        @initial = state_name
      end

      @states[state_name] = State.new(state_name)
      define_state_name_question_method(state_name)
    end

    def event(event_name)
      transitions = yield
      @events[event_name.to_sym] = transitions
      destination_state = transitions.to

      define_predicate_method(event_name, destination_state)
      define_transition_method(event_name, destination_state)
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

    def define_state_name_question_method(state_name)
      define_method "#{state_name}?" do
        current_state == state_name.to_sym
      end
    end

    def define_predicate_method(event_name, destination_state)
      define_method "can_#{event_name}?" do
        self.class.events[event_name.to_sym]
          .transition?(from: current_state, to: destination_state, caller: self)
      end
    end

    def define_transition_method(event_name, destination_state)
      define_method "#{event_name}!" do
        original_state = current_state

        validate_transition(event_name, original_state, destination_state)

        invoke_callbacks(self.class.before_callbacks, original_state, destination_state)
        self.current_state = destination_state
        invoke_callbacks(self.class.after_callbacks, original_state, destination_state)
      end
    end

    def before_transition(code, options)
      @before_callbacks << Callback.new(from: options[:from], to: options[:to], code: code)
    end

    def after_transition(code, options)
      @after_callbacks << Callback.new(from: options[:from], to: options[:to], code: code)
    end
  end
end
