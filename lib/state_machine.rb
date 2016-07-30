module StateMachine
  def self.included(base)
    base.extend(ClassMethods)
    base.instance_variable_set(:@states, {})
    base.instance_variable_set(:@initial, nil)
  end

  module ClassMethods
    def state(name, options = {})
      @states[name] = State.new(name)
      if options[:initial]
        raise InitialStateAlreadyDefined.new(@initial) if @initial
        @initial = name
      end
    end

    def event(name, &block)
      yield
    end

    def transitions(from: , to:)
      validate_states(from, to)
    end

    def validate_states(*states)
      states.flatten.each do |state|
        raise UndefinedStateError.new(state) unless @states.has_key?(state)
      end
    end
  end

  class StateMachineError < StandardError; end
  class UndefinedStateError < StateMachineError
    def initialize(state_name)
      @state_name = state_name
    end

    def to_s
      "State #{@state_name} has not been defined"
    end
  end
  class InitialStateAlreadyDefined < StateMachineError
    def to_s
      'Initial state has already been defined'
    end
  end
  class InitialStateMissing < StateMachineError; end
end

class State
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end
