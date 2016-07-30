module StateMachine
  class Event
    attr_reader :to

    def initialize(from:, to:)
      @from = Helpers.coerce_array(from).map(&:to_sym)
      @to = to.to_sym
    end

    def transition?(from:, to:)
      @from.include?(from) && @to == to
    end
  end
end
