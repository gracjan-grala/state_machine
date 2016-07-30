module StateMachine
  class State
    attr_accessor :name, :allowed_transitions

    def initialize(name)
      @name = name
      @allowed_transitions = []
    end

    def can_transition_to?(state)
    end
  end
end
