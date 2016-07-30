require_relative './exceptions'

module StateMachine
  class Event
    attr_reader :to

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
      @guard.nil? || !!invoke_guard(caller)
    end

    def invoke_guard(caller)
      return @guard.call if @guard.is_a?(Proc)
      caller.send(@guard) if @guard.is_a?(Symbol)
    end
  end
end
