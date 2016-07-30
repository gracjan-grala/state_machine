module StateMachine
  module ClassDefinition
    attr_reader :states, :initial

    def state(name, options = {})
      if options[:initial]
        if @initial
          raise Error::InitialStateAlreadyDefined, 'Initial state has already been defined'
        end
        @initial = name
      end

      @states[name] = State.new(name)
      define_method "#{name}?" do
        current_state == name.to_sym
      end
    end

    def event(name, &block)
      yield

      define_method "#{name}!" do
        self.current_state = name
      end

      define_method "can_#{name}?" do
        true
      end
    end

    def transitions(from:, to:)
      validate_states(from, to)
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
