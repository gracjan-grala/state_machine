module StateMachine
  class Event
    attr_reader :from, :to

    def initialize(from:, to:, guard: nil)
      raise Errors::InvalidDestinationState unless to.respond_to?(:to_sym)

      @from = Helpers.coerce_array(from).map(&:to_sym)
      @to = to.to_sym
      @guard = guard
    end

    def transition?(from:, to:, caller: nil)
      @from.include?(from) && @to == to && guard_clause_passed?(caller)
    end

    private

    def guard_clause_passed?(caller)
      @guard.nil? || !!Helpers.invoke_code_on_caller(@guard, caller)
    end
  end
end
