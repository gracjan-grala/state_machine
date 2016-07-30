module StateMachine
  class Callback
    def initialize(from: nil, to: nil, code:)
      @from = from
      @to = to
      @code = code
    end

    def invoke_if_matches(from:, to:, caller:)
      Helpers.invoke_code_on_caller(@code, caller) if matches?(from: from, to: to)
    end

    def matches?(from:, to:)
      (@from.nil? || @from == from) && (@to.nil? || @to == to)
    end
  end
end
